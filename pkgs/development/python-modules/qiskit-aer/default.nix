{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
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
  version = "0.4.1";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
    fetchSubmodules = true; # fetch muparserx and other required libraries
    sha256 = "1j2pv6jx5dlzanjp1qnf32s53d8jrlpv96nvymznkcnjvqn60gv9";
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

  prePatch = ''
    # remove dependency on PyPi cmake package, which isn't in Nixpkgs
    substituteInPlace setup.py --replace "'cmake'" ""
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

  preCheck = ''
    # Tests include a compiled "circuit" which is auto-built in $HOME
    export HOME=$(mktemp -d)
    # move tests b/c by default try to find (missing) cython-ized code in /build/source dir
    cp -r test $HOME

    # Add qiskit-aer compiled files to cython include search
    pushd $HOME
  '';
  postCheck = ''
    popd
  '';

  meta = with lib; {
    description = "High performance simulators for Qiskit";
    homepage = "https://github.com/QISKit/qiskit-aer";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
