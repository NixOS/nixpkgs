{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
  # Python requirements
, cython
, dill
, fastjsonschema
, jsonschema
, numpy
, marshmallow
, marshmallow-polyfield
, networkx
, ply
, psutil
, python-constraint
, retworkx
, scipy
, sympy
  # Python visualization requirements, semi-optional
, ipywidgets
, matplotlib
, pillow
, pydot
, pygments
, pylatexenc
, seaborn
  # test requirements
, ddt
, hypothesis
, nbformat
, nbconvert
, pytestCheckHook
, python
}:

buildPythonPackage rec {
  pname = "qiskit-terra";
  version = "0.14.2";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
    sha256 = "0p5wapjvy81pnks100xbb23kbs2wyys9ykyc8z4968wl487lq4g5";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    dill
    fastjsonschema
    jsonschema
    numpy
    marshmallow
    marshmallow-polyfield
    matplotlib
    networkx
    ply
    psutil
    python-constraint
    retworkx
    scipy
    sympy
    # Optional/visualization inputs
    ipywidgets
    matplotlib
    pillow
    pydot
    pygments
    pylatexenc
    seaborn
  ];

  postPatch = ''
    # Fix relative imports in tests
    touch test/python/dagcircuit/__init__.py
  '';

  # *** Tests ***
  checkInputs = [
    ddt
    hypothesis
    nbformat
    nbconvert
    pytestCheckHook
  ];
  dontUseSetuptoolsCheck = true;  # can't find setup.py, so fails. tested by pytest

  pythonImportsCheck = [
    "qiskit"
    "qiskit.transpiler.passes.routing.cython.stochastic_swap.swap_trial"
  ];

  disabledTests = [
    "test_random_clifford_valid"  # random test, fails at least once when testing locally.
  ];
  pytestFlagsArray = [
    "--ignore=test/randomized/test_transpiler_equivalence.py" # collection requires qiskit-aer, which would cause circular dependency
  ];

  # Moves tests to $PACKAGEDIR/test. They can't be run from /build because of finding
  # cythonized modules and expecting to find some resource files in the test directory.
  preCheck = ''
    export PACKAGEDIR=$out/${python.sitePackages}
    echo "Moving Qiskit test files to package directory"
    cp -r $TMP/source/test $PACKAGEDIR
    cp -r $TMP/source/examples $PACKAGEDIR
    cp -r $TMP/source/qiskit/schemas/examples $PACKAGEDIR/qiskit/schemas/

    # run pytest from Nix's $out path
    pushd $PACKAGEDIR
  '';
  postCheck = ''
    rm -rf test
    rm -rf examples
    popd
  '';


  meta = with lib; {
    description = "Provides the foundations for Qiskit.";
    longDescription = ''
      Allows the user to write quantum circuits easily, and takes care of the constraints of real hardware.
    '';
    homepage = "https://qiskit.org/terra";
    downloadPage = "https://github.com/QISKit/qiskit-terra/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
