{stdenv, fetchurl, bison, pkgconfig, glib}:

stdenv.mkDerivation {
  name = "mono-1.1.4";
  src = fetchurl {
    url = http://nixos.org/tarballs/mono-1.1.4.tar.gz;
    md5 = "66755e5f201e912cecdd19807ba62487";
  };

  buildInputs = [bison pkgconfig glib];
  propagatedBuildInputs = [glib];

  preBuild = "
    makeFlagsArray=(INSTALL=`type -tp install`)
  ";
}
