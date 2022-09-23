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
, R
}:

buildPythonPackage rec {
  pname = "CNVkit";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "etal";
    repo = "cnvkit";
    rev = "v${version}";
    sha256 = "1q4l7jhr1k135an3n9aa9wsid5lk6fwxb0hcldrr6v6y76zi4gj1";
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

  checkInputs = [ R ];

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
    license = licenses.asl20;
    maintainers = [ maintainers.jbedo ];
  };
}
