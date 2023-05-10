{ lib
, fetchFromGitHub
, fetchpatch
, rPackages
, buildPythonPackage
, biopython
, numpy
, scipy
, scikit-learn
, pandas
, matplotlib
, reportlab
, pysam
, future
, pillow
, pomegranate
, pyfaidx
, python
, pythonOlder
, R
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cnvkit";
  version = "0.9.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "etal";
    repo = "cnvkit";
    rev = "refs/tags/v${version}";
    hash = "sha256-mCQXo3abwC06x/g51UBshqUk3dpqEVNUvx+cJ/EdYGQ=";
  };

  propagatedBuildInputs = [
    biopython
    numpy
    scipy
    scikit-learn
    pandas
    matplotlib
    reportlab
    pyfaidx
    pysam
    future
    pillow
    pomegranate
    rPackages.DNAcopy
    pytestCheckHook
  ];

  nativeCheckInputs = [ R pytestCheckHook ];

  # cnvkit uses functions from before the rewrite of pomegranate to use pytorch
  # and hence these tests fail.
  disabledTests = [
    "test_segment_hmm"
    "test_batch"
  ];

  pythonImportsCheck = [
    "cnvlib"
  ];

  meta = with lib; {
    homepage = "https://cnvkit.readthedocs.io";
    description = "A Python library and command-line software toolkit to infer and visualize copy number from high-throughput DNA sequencing data";
    changelog = "https://github.com/etal/cnvkit/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.jbedo ];
  };
}
