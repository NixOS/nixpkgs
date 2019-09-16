{ lib
, fetchPypi
, rPackages
, rWrapper
, buildPythonPackage
, biopython
, numpy
, scipy
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
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hj8c98s538i0hg5mrz4bw4v07qmcl51rhxq611rj2nglnc9r25y";
  };

  propagatedBuildInputs = [
    biopython
    numpy
    scipy
    pandas
    matplotlib
    reportlab
    pyfaidx
    pysam
    future
    pillow
    pomegranate
  ];

  meta = with lib; {
    homepage = "https://cnvkit.readthedocs.io";
    description = "A Python library and command-line software toolkit to infer and visualize copy number from high-throughput DNA sequencing data";
    license = licenses.asl20;
    maintainers = [ maintainers.jbedo ];
  };
}
