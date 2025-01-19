{
  lib,
  fetchFromGitHub,
  rPackages,
  buildPythonPackage,
  biopython,
  numpy,
  scipy,
  scikit-learn,
  pandas,
  matplotlib,
  reportlab,
  pysam,
  future,
  pillow,
  pomegranate,
  pyfaidx,
  python,
  pythonOlder,
  R,
  setuptools,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "cnvkit";
  version = "0.9.12-unstable-2025-01-16";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "etal";
    repo = "cnvkit";
    rev = "5cb6aeaf40ea5572063cf9914c456c307b7ddf7a";
    hash = "sha256-2x7xZNIOCnb76ek9ENAkKMRexA+8Vv9fsCm7zIVBMlU=";
  };

  patches = [
    (fetchpatch {
      name = "pomegranate-1.patch";
      url = "https://github.com/etal/cnvkit/commit/ee6beabdcfc89d80acb6519a5643a05cad84213f.patch";
      hash = "sha256-g9h/4CpbGmfxH+Jo5+anICtUC5yL9f3169eUuBquBso=";
    })
    (fetchpatch {
      name = "pomegranate-2.patch";
      url = "https://github.com/etal/cnvkit/commit/e759acf8cced2d3ceef06a1c0a75a01e16902814.patch";
      hash = "sha256-ReTmldBzLmkOdIn9QZjDBPKglpvViXwa3s4/Pm8Q6gY=";
    })
  ];

  postPatch = ''
    substituteInPlace requirements/core.txt \
      --replace-fail "pomegranate >=0.14.8, <1.0.0" "pomegranate"
    substituteInPlace requirements/min.txt \
      --replace-fail "pomegranate == 0.14.8" "pomegranate"
    # see https://github.com/etal/cnvkit/issues/680
    substituteInPlace test/test_io.py \
      --replace-fail 'test_read_vcf' 'dont_test_read_vcf'
  '';

  build-system = [ setuptools ];

  dependencies = [
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
  ];

  nativeCheckInputs = [ R ];

  checkPhase = ''
    runHook preCheck

    pushd test/
    ${python.interpreter} test_io.py
    # ${python.interpreter} test_genome.py
    ${python.interpreter} test_cnvlib.py
    # ${python.interpreter} test_commands.py
    ${python.interpreter} test_r.py
    popd # test/

    runHook postCheck
  '';

  pythonImportsCheck = [ "cnvlib" ];

  meta = {
    homepage = "https://cnvkit.readthedocs.io";
    description = "Python library and command-line software toolkit to infer and visualize copy number from high-throughput DNA sequencing data";
    changelog = "https://github.com/etal/cnvkit/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jbedo ];
  };
}
