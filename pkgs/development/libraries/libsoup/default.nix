{ stdenv, fetchurl, glib, libxml2, pkgconfig, intltool, python
, gnomeSupport ? true, libgnome_keyring, sqlite, glib_networking }:

stdenv.mkDerivation {
  name = "libsoup-2.40.3";

  src = fetchurl {
    url = mirror://gnome/sources/libsoup/2.40/libsoup-2.40.3.tar.xz;
    sha256 = "82c92f1f6f4cbfd501df783ed87e7de9410b4a12a3bb0b19c64722e185d2bbc9";
  };

  nativeBuildInputs = [ pkgconfig intltool python ];

  propagatedBuildInputs = [ glib libxml2 ]
    ++ stdenv.lib.optionals gnomeSupport [ libgnome_keyring sqlite ];

  passthru.propagatedUserEnvPackages = [ glib_networking ];

  # glib_networking is a runtime dependency, not a compile-time dependency
  configureFlags = "--disable-tls-check";

  preConfigure = ''
    substituteInPlace libsoup/tld-parser.py \
      --replace "/usr/bin/env python" ${python}/bin/python
  '';

  meta = {
    inherit (glib.meta) maintainers platforms;
  };
}
