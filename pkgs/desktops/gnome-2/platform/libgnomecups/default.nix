{ lib, stdenv, fetchurl, pkg-config, gtk2, gettext, libxml2, intltool, libart_lgpl }:

stdenv.mkDerivation rec {
  pname = "libgnomecups";
  version = "0.2.3";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnomecups/${lib.versions.majorMinor version}/libgnomecups-${version}.tar.bz2";
    sha256 = "0a8xdaxzz2wc0n1fjcav65093gixzyac3948l8cxx1mk884yhc71";
  };

  hardeningDisable = [ "format" ];

  patches = [ ./glib.patch ./cups_1.6.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 gettext intltool libart_lgpl ];

  propagatedBuildInputs = [ libxml2 ];
}
