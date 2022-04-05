{ lib, stdenv, fetchurl, fetchpatch, pkg-config, gtk2, gettext, libxml2, intltool, libart_lgpl
, libgnomecups, bison, flex }:

stdenv.mkDerivation rec {
  pname = "libgnomeprint";
  version = "2.18.8";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnomeprint/${lib.versions.majorMinor version}/libgnomeprint-${version}.tar.bz2";
    sha256 = "1034ec8651051f84d2424e7a1da61c530422cc20ce5b2d9e107e1e46778d9691";
  };

  patches = [
    ./bug653388.patch
    # Fix compatibility with bison 3
    (fetchpatch {
      url = "https://github.com/pld-linux/libgnomeprint/raw/54c0f9c3675b86c53f6d77a5bc526ce9ef0e38cd/bison3.patch";
      sha256 = "1sp04jbv34i1gcwf377hhmwdsmqzig70dd06rjz1isb6zwh4y01l";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 gettext intltool libart_lgpl libgnomecups bison flex ];

  propagatedBuildInputs = [ libxml2 ];

  meta = with lib; {
    platforms = platforms.linux;
  };
}
