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

  postPatch = ''
    # see https://github.com/etal/cnvkit/issues/589
    substituteInPlace setup.py \
      --replace 'joblib < 1.0' 'joblib'
    # see https://github.com/etal/cnvkit/issues/680
    substituteInPlace test/test_io.py \
      --replace 'test_read_vcf' 'dont_test_read_vcf'
  '';

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
  ];

  nativeCheckInputs = [ R ];

  checkPhase = ''
    pushd test/
    ${python.interpreter} test_io.py
    ${python.interpreter} test_genome.py
    ${python.interpreter} test_cnvlib.py
    ${python.interpreter} test_commands.py
    ${python.interpreter} test_r.py
    popd # test/
  '';

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
