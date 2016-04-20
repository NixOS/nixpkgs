{ stdenv, fetchurl, fetchpatch, pkgconfig, gnum4 }:
let
  ver_maj = "2.8"; # odd major numbers are unstable
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "libsigc++-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsigc++/${ver_maj}/${name}.tar.xz";
    sha256 = "0lcnzzdq6718znfshs1hflpwqq6awbzwdyp4kv5lfaf54z880jbp";
  };
  patches = [(fetchpatch {
    url = "https://anonscm.debian.org/cgit/collab-maint/libsigc++-2.0.git/plain"
      + "/debian/patches/0002-Enforce-c-11-via-pkg-config.patch?id=d451a4d195b1";
    sha256 = "19g19473syp2z3kg8vdrli89lm9kcvaqajkqfmdig1vfpkbq0nci";
  })];

  nativeBuildInputs = [ pkgconfig gnum4 ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://libsigc.sourceforge.net/;
    description = "A typesafe callback system for standard C++";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
