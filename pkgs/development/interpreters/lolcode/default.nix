{ stdenv, fetchurl, pkgconfig, doxygen, cmake }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "lolcode-${version}";
  version = "0.10.5";

  src = fetchurl {
    url = "https://github.com/justinmeza/lci/archive/v${version}.tar.gz";
    sha256 = "0g6k1jxnvgjxyidrvgk8pdb8y8mai456j9zpzmvhm6fr22c4skrc";
  };

  buildInputs = [ pkgconfig doxygen cmake ];

  # Maybe it clashes with lci scientific logic software package...
  postInstall = "mv $out/bin/lci $out/bin/lolcode-lci";

  meta = {
    homepage = http://lolcode.org;
    description = "An esoteric programming language";
    longDescription = ''
      LOLCODE is a funny esoteric  programming language, a bit Pascal-like,
      whose keywords are LOLspeak.
    '';
    license = licenses.gpl3;
    maintainers = [ maintainers.AndersonTorres ];
  };

}
