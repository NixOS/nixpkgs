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
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "etal";
    repo = "cnvkit";
    rev = "v${version}";
    sha256 = "022zplgqil5l76vri647cyjx427vnbg5r2gw6lw712d2janvdjm7";
  };

  patches = [
    # Fix: AttributeError: module 'pandas.io.common' has no attribute 'EmptyDataError'
    (fetchpatch {
      url = "https://github.com/etal/cnvkit/commit/392adfffedfa0415e635b72c5027835b0a8d7ab5.patch";
      sha256 = "0s0gwyy0hybmhc3jij2v9l44b6lkcmclii8bkwsazzj2kc24m2rh";
    })
  ];

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
  '';

  meta = with lib; {
    homepage = "https://cnvkit.readthedocs.io";
    description = "A Python library and command-line software toolkit to infer and visualize copy number from high-throughput DNA sequencing data";
    license = licenses.asl20;
    maintainers = [ maintainers.jbedo ];
  };
}
