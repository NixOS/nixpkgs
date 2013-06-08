{ stdenv, fetchurl, pkgconfig, gtk, gettext, libxml2, intltool, libart_lgpl
, libgnomecups, bison, flex }:

stdenv.mkDerivation rec {
  name = "libgnomeprint-2.18.8";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnomeprint/2.18/${name}.tar.bz2";
    sha256 = "1034ec8651051f84d2424e7a1da61c530422cc20ce5b2d9e107e1e46778d9691";
  };

  patches = [ ./bug653388.patch ];

  buildInputs = [ pkgconfig gtk gettext intltool libart_lgpl libgnomecups bison flex ];

  propagatedBuildInputs = [ libxml2 ];
}
