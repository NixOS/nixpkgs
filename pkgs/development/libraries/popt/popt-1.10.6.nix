{stdenv, fetchurl, gettext, libtool, autoconf, automake}:

assert gettext != null;

stdenv.mkDerivation {
  builder = ./builder-1.10.6.sh;
  name = "popt-1.10.6";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/popt-1.10.6.tar.gz;
    md5 = "130ee632bd4c677d898b0ef5efa67666";
  };
  buildInputs = [gettext libtool automake autoconf];
}
