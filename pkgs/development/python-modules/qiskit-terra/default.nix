{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, cython
, dill
, jsonschema
, numpy
, marshmallow
, marshmallow-polyfield
, matplotlib
, networkx
, ply
, psutil
, scipy
, sympy
  # test requirements
, ddt
, hypothesis
, ipywidgets
, nbformat
, nbconvert
, pillow
, pydot
, python
, pygraphviz
, pylatexenc
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qiskit-terra";
  version = "0.12.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
    sha256 = "1yarfziy2w8n1d7zyyxykfs68608j8md4kwfyhbyc6wy483fk9sy";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    dill
    jsonschema
    numpy
    marshmallow
    marshmallow-polyfield
    matplotlib
    networkx
    ply
    psutil
    scipy
    sympy
  ];


  # *** Tests ***
  checkInputs = [
    ddt
    hypothesis
    ipywidgets
    nbformat
    nbconvert
    pillow
    pydot
    pygraphviz
    pylatexenc
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "qiskit"
    "qiskit.transpiler.passes.routing.cython.stochastic_swap.swap_trial"
  ];

  dontUseSetuptoolsCheck = true;  # can't find setup.py, so fails. tested by pytest

  disabledTests = [
    "test_long_name"  # generated circuit images differ for some reason
    "test_jupyter_jobs_pbars" # needs IBMQ provider package (qiskit-ibmq-provider), circular dependency
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
    homepage = "https://github.com/QISKit/qiskit-terra";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
