{ lib, buildPythonPackage, fetchFromGitHub, cython, numpy, pysam, matplotlib, python, isPy27, isPy3k }:
buildPythonPackage rec {
  version = "0.12.4";
  format = "setuptools";
  pname = "htseq";

  src = fetchFromGitHub {
    owner = "htseq";
    repo = "htseq";
    rev = "release_${version}";
    sha256 = "0y7vh249sljqjnv81060w4xkdx6f1y5zdqkh38yk926x6v9riijm";
  };

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ numpy pysam matplotlib ];

  checkPhase = lib.optionalString isPy27 ''
    ${python.interpreter} python2/test/test_general.py
  '' + lib.optionalString isPy3k ''
    ${python.interpreter} python3/test/test_general.py
  '';

  meta = with lib; {
    homepage = "https://htseq.readthedocs.io/";
    description = "A framework to work with high-throughput sequencing data";
    maintainers = with maintainers; [ unode ];
    platforms = platforms.unix;
  };
}
