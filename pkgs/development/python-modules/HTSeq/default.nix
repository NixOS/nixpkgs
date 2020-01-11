{ stdenv, buildPythonPackage, fetchPypi, cython, numpy, pysam, matplotlib
}:
buildPythonPackage rec {
  version = "0.11.2";
  pname = "HTSeq";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65c4c13968506c7df92e97124df96fdd041c4476c12a548d67350ba8b436bcfc";
  };

  buildInputs = [ cython numpy pysam ];
  propagatedBuildInputs = [ numpy pysam matplotlib ];

  meta = with stdenv.lib; {
    description = "A framework to work with high-throughput sequencing data";
    maintainers = with maintainers; [ unode ];
    platforms = platforms.unix;
  };
}
