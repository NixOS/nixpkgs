{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # dependencies
  R,
  biopython,
  matplotlib,
  numpy,
  pandas,
  pomegranate,
  pyfaidx,
  pysam,
  rPackages,
  reportlab,
  scikit-learn,
  scipy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cnvkit";
  version = "0.9.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "etal";
    repo = "cnvkit";
    tag = "v${version}";
    hash = "sha256-ZdE3EUNZpEXRHTRKwVhuj3BWQWczpdFbg4pVr0+AHiQ=";
  };

  patches = [
    (fetchpatch {
      name = "fix-numpy2-compat";
      url = "https://github.com/etal/cnvkit/commit/5cb6aeaf40ea5572063cf9914c456c307b7ddf7a.patch";
      hash = "sha256-VwGAMGKuX2Kx9xL9GX/PB94/7LkT0dSLbWIfVO8F9NI=";
    })
  ];

  pythonRelaxDeps = [
    # https://github.com/etal/cnvkit/issues/815
    "pomegranate"
  ];

  # Numpy 2 compatibility
  postPatch = ''
    substituteInPlace skgenome/intersect.py \
      --replace-fail "np.string_" "np.bytes_"
  '';

  dependencies = [
    biopython
    matplotlib
    numpy
    pandas
    pomegranate
    pyfaidx
    pysam
    rPackages.DNAcopy
    reportlab
    scikit-learn
    scipy
  ];

  pythonImportsCheck = [ "cnvlib" ];

  nativeCheckInputs = [
    pytestCheckHook
    R
  ];

  disabledTests = [
    # AttributeError: module 'pomegranate' has no attribute 'NormalDistribution'
    # https://github.com/etal/cnvkit/issues/815
    "test_batch"
    "test_segment_hmm"
  ];

  meta = {
    homepage = "https://cnvkit.readthedocs.io";
    description = "Python library and command-line software toolkit to infer and visualize copy number from high-throughput DNA sequencing data";
    changelog = "https://github.com/etal/cnvkit/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jbedo ];
  };
}
