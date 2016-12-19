{ stdenv, fetchFromGitHub, curl, libxml2 }:

stdenv.mkDerivation {
  name = "libs3-2015-04-23";

  src = fetchFromGitHub {
    owner = "bji";
    repo = "libs3";
    rev = "11a4e976c28ba525e7d61fbc3867c345a2af1519";
    sha256 = "0xjjwyw14sk9am6s2m25hxi55vmsrc2yiawd6ln2lvg59xjcr48i";
  };

  buildInputs = [ curl libxml2 ];

  DESTDIR = "\${out}";

  meta = with stdenv.lib; {
    homepage = https://github.com/bji/libs3;
    description = "A library for interfacing with amazon s3";
    license = licenses.lgpl3;
    platforms = platforms.linux;
  };
}
