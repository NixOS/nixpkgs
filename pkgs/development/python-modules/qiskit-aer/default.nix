{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, cmake
, cvxpy
, cython
, numpy
, openblas
, pybind11
, scikit-build
, spdlog
  # Check Inputs
, qiskit-terra
, pytestCheckHook
, python
}:

buildPythonPackage rec {
  pname = "qiskit-aer";
  version = "0.5.2";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-aer";
    rev = version;
    fetchSubmodules = true; # fetch muparserx and other required libraries
    sha256 = "0vw6b69h8pvzxhaz3k8sg9ac792gz3kklfv0izs6ra83y1dfwhjz";
  };

  nativeBuildInputs = [
    cmake
    scikit-build
  ];

  buildInputs = [
    openblas
    spdlog
  ];

  propagatedBuildInputs = [
    cvxpy
    cython  # generates some cython files at runtime that need to be cython-ized
    numpy
    pybind11
  ];

  postPatch = ''
    # remove dependency on PyPi cmake package, which isn't in Nixpkgs
    substituteInPlace setup.py --replace "'cmake!=3.17,!=3.17.0'" ""
  '';

  dontUseCmakeConfigure = true;

  cmakeFlags = [
    "-DBUILD_TESTS=True"
    "-DAER_THRUST_BACKEND=OMP"
  ];

  # Needed to find qiskit.providers.aer modules in cython. This exists in GitHub, don't know why it isn't copied by default
  postFixup = ''
    touch $out/${python.sitePackages}/qiskit/__init__.pxd
  '';

  # *** Testing ***

  pythonImportsCheck = [
    "qiskit.providers.aer"
    "qiskit.providers.aer.backends.qasm_simulator"
    "qiskit.providers.aer.backends.controller_wrappers" # Checks C++ files built correctly. Only exists if built & moved to output
  ];
  checkInputs = [
    qiskit-terra
    pytestCheckHook
  ];
  dontUseSetuptoolsCheck = true;  # Otherwise runs tests twice
  disabledTests = [
    # broken with cvxpy >= 1.1.0, see https://github.com/Qiskit/qiskit-aer/issues/779.
    # TODO: Remove once resolved, probably next qiskit-aer version
    "test_clifford"
  ];

  preCheck = ''
    # Tests include a compiled "circuit" which is auto-built in $HOME
    export HOME=$(mktemp -d)
    # move tests b/c by default try to find (missing) cython-ized code in /build/source dir
    cp -r $TMP/$sourceRoot/test $HOME

    # Add qiskit-aer compiled files to cython include search
    pushd $HOME
  '';
  postCheck = ''
    popd
  '';

  meta = with lib; {
    description = "High performance simulators for Qiskit";
    homepage = "https://qiskit.org/aer";
    downloadPage = "https://github.com/QISKit/qiskit-aer/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
    # Doesn't build on aarch64 (libmuparserx issue).
    # Can fix by building muparserx from source (https://github.com/beltoforion/muparserx)
    # or in future updates (e.g. Raspberry Pi enabled via https://github.com/Qiskit/qiskit-aer/pull/651 & https://github.com/Qiskit/qiskit-aer/pull/660)
    platforms = platforms.x86_64;
  };
}
