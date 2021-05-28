{ stdenv, buildPythonPackage, fetchPypi, cython, numpy, pysam, matplotlib
}:
buildPythonPackage rec {
  version = "0.12.4";
  pname = "HTSeq";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e3980bb4f12899442b4fa6f24f0ba149090f71cedb1eaf7128249afe4eb921ff";
  };

  buildInputs = [ cython numpy pysam ];
  propagatedBuildInputs = [ numpy pysam matplotlib ];

  meta = with stdenv.lib; {
    description = "A framework to work with high-throughput sequencing data";
    maintainers = with maintainers; [ unode ];
    platforms = platforms.unix;
  };
}
