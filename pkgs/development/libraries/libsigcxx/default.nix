{ stdenv, fetchurl, pkgconfig, gnum4 }:
let
  ver_maj = "2.6"; # odd major numbers are unstable
  ver_min = "2";
in
stdenv.mkDerivation rec {
  name = "libsigc++-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsigc++/${ver_maj}/${name}.tar.xz";
    sha256 = "fdace7134c31de792c17570f9049ca0657909b28c4c70ec4882f91a03de54437";
  };

  nativeBuildInputs = [ pkgconfig gnum4 ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://libsigc.sourceforge.net/;
    description = "A typesafe callback system for standard C++";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
