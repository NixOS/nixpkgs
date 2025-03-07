{
  lib,
  buildPythonPackage,
  demes,
  fetchPypi,
  gsl,
  newick,
  numpy,
  oldest-supported-numpy,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools-scm,
  tskit,
  wheel,
}:

buildPythonPackage rec {
  pname = "msprime";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s/Ys1RatLkPIQS6h8kKsrRvJOTkc/pyqGWJYdOLjSDU=";
  };

  nativeBuildInputs = [
    gsl
    oldest-supported-numpy
    setuptools-scm
    wheel
  ];

  buildInputs = [ gsl ];

  propagatedBuildInputs = [
    numpy
    newick
    tskit
    demes
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    scipy
  ];

  disabledTests = [
    "tests/test_ancestry.py::TestSimulator::test_debug_logging"
    "tests/test_ancestry.py::TestSimulator::test_debug_logging_dtw"
  ];

  disabledTestPaths = [
    "tests/test_demography.py"
    "tests/test_algorithms.py"
    "tests/test_provenance.py"
    "tests/test_dict_encoding.py"
  ];

  # `python -m pytest` puts $PWD in sys.path, which causes the extension
  # modules imported as `msprime._msprime` to be unavailable, failing the
  # tests. This deletes the `msprime` folder such that only what's installed in
  # $out is used for the imports. See also discussion at:
  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    rm -r msprime
  '';
  pythonImportsCheck = [ "msprime" ];

  meta = with lib; {
    description = "Simulate genealogical trees and genomic sequence data using population genetic models";
    homepage = "https://github.com/tskit-dev/msprime";
    changelog = "https://github.com/tskit-dev/msprime/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ alxsimon ];
  };
}
