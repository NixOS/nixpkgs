{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "tcl-8.4.11";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/tcl8.4.11-src.tar.gz;
    md5 = "629dfea34e4087eb4683f834060abb63";
  };
}
