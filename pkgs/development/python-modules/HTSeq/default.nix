{ stdenv, buildPythonPackage, fetchPypi, cython, numpy, pysam, matplotlib
}:
buildPythonPackage rec {
  version = "0.11.4";
  pname = "HTSeq";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ncn30yvc18aiv1qsa0bvcbjwqy21s0a0kv3v0vghzsn8vbfzq7h";
  };

  buildInputs = [ cython numpy pysam ];
  propagatedBuildInputs = [ numpy pysam matplotlib ];

  meta = with stdenv.lib; {
    description = "A framework to work with high-throughput sequencing data";
    maintainers = with maintainers; [ unode ];
    platforms = platforms.unix;
  };
}
