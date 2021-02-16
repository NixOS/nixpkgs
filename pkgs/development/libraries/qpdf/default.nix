{ lib, stdenv, fetchFromGitHub, libjpeg, zlib, perl }:

stdenv.mkDerivation rec {
  pname = "qpdf";
  version = "10.1.0";

  src = fetchFromGitHub {
    owner = "qpdf";
    repo = "qpdf";
    rev = "release-qpdf-${version}";
    sha256 = "sha256-abPT1u/ceBrE1U+omOHiU3UjLrmcpdSpe1vgar0wUGk=";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib libjpeg ];

  preCheck = ''
    patchShebangs qtest/bin/qtest-driver
  '';

  doCheck = true;
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://qpdf.sourceforge.net/";
    description = "A C++ library and set of programs that inspect and manipulate the structure of PDF files";
    license = licenses.asl20; # as of 7.0.0, people may stay at artistic2
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.all;
  };
}
