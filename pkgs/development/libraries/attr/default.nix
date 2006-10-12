{stdenv, fetchurl, autoconf, libtool, gettext}:

stdenv.mkDerivation {
  name = "attr-2.4.32";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/attr_2.4.32-1.tar.gz;
    md5 = "092739e9b944815aecc1f5d8379d5ea5";
  };

  buildInputs = [autoconf libtool gettext];
  patches = [./attr-2.4.32.patch ./attr-2.4.32-makefile.patch];
}
