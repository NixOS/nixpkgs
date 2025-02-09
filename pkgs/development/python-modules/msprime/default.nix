{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, oldest-supported-numpy
, setuptools-scm
, wheel
, pythonOlder
, gsl
, numpy
, newick
, tskit
, demes
, pytestCheckHook
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

  patches = [
    # upstream patch fixes 2 failing unittests. remove on update
    (fetchpatch {
      name = "python311.patch";
      url = "https://github.com/tskit-dev/msprime/commit/639125ec942cb898cf4a80638f229e11ce393fbc.patch";
      hash = "sha256-peli4tdu8Bv21xIa5H8SRdfjQnTMO72IPFqybmSBSO8=";
      includes = [ "tests/test_ancestry.py" ];
    })
  ];

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
