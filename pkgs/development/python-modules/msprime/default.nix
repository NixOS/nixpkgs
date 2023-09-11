{ lib
, buildPythonPackage
, fetchPypi
, oldest-supported-numpy
, setuptools-scm
, wheel
, pythonOlder
, gsl
, numpy
, newick
, tskit
, demes
, pytest
, pytest-xdist
, scipy
}:

buildPythonPackage rec {
  pname = "msprime";
  version = "1.2.0";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YAJa2f0w2CenKubnYLbP8HodDhabLB2hAkyw/CPkp6o=";
  };

  nativeBuildInputs = [
    gsl
    oldest-supported-numpy
    setuptools-scm
    wheel
  ];

  buildInputs = [
    gsl
  ];

  propagatedBuildInputs = [
    numpy
    newick
    tskit
    demes
  ];

  nativeCheckInputs = [
    pytest
    pytest-xdist
    scipy
  ];

  checkPhase = ''
    runHook preCheck

    # avoid adding the current directory to sys.path
    # https://docs.pytest.org/en/7.1.x/explanation/pythonpath.html#invoking-pytest-versus-python-m-pytest
    # need pythonPackages.stdpopsim
    # need pythonPackages.bintrees
    # need pythonPachages.python_jsonschema_objects
    # ModuleNotFoundError: No module named 'lwt_interface.dict_encoding_testlib'
    # fails for python311
    # fails for python311
    pytest -v --import-mode append \
      --ignore=tests/test_demography.py \
      --ignore=tests/test_algorithms.py \
      --ignore=tests/test_provenance.py \
      --ignore=tests/test_dict_encoding.py \
      --deselect=tests/test_ancestry.py::TestSimulator::test_debug_logging \
      --deselect=tests/test_ancestry.py::TestSimulator::test_debug_logging_dtwf

    runHook postCheck
  '';

  pythonImportsCheck = [
    "msprime"
  ];

  meta = with lib; {
    description = "Simulate genealogical trees and genomic sequence data using population genetic models";
    homepage = "https://github.com/tskit-dev/msprime";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ alxsimon ];
  };
}
