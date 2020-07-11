{ lib
, fetchPypi
, rPackages
, rWrapper
, buildPythonPackage
, biopython
, numpy
, scipy
, scikitlearn
, pandas
, matplotlib
, reportlab
, pysam
, future
, pillow
, pomegranate
, pyfaidx
}:

buildPythonPackage rec {
  pname = "CNVkit";
  version = "0.9.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d68adc0121e17c61a3aa28c0a9ba6526510a5a0df0f0a6eb1818bab71b7e927a";
  };

  propagatedBuildInputs = [
    biopython
    numpy
    scipy
    scikitlearn
    pandas
    matplotlib
    reportlab
    pyfaidx
    pysam
    future
    pillow
    pomegranate
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pandas >= 0.20.1, < 0.25.0" "pandas"
  '';

  pythonImportsCheck = [ "cnvlib" ];

  meta = with lib; {
    homepage = "https://cnvkit.readthedocs.io";
    description = "A Python library and command-line software toolkit to infer and visualize copy number from high-throughput DNA sequencing data";
    license = licenses.asl20;
    maintainers = [ maintainers.jbedo ];
  };
}
