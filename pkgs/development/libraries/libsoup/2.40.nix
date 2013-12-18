{ stdenv, fetchurl, pkgconfig, glib, libxml2, sqlite, intltool, python
, gnomeSupport ? true, libgnome_keyring, glib_networking
}:

stdenv.mkDerivation {
  name = "libsoup-2.44.2";

  src = fetchurl {
    url = mirror://gnome/sources/libsoup/2.44/libsoup-2.44.2.tar.xz;
    sha256 = "1wwqsmi1jvidiqwbdnjl66nmk1yja8w9dxf9cz10zh56fjmvbr77";
  };


  preConfigure = ''
    substituteInPlace libsoup/tld-parser.py \
      --replace "!/usr/bin/env python" "!${python}/bin/${python.executable}"
  '';
  buildInputs = [ pkgconfig intltool python ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libxml2 sqlite ]
    ++ stdenv.lib.optionals gnomeSupport [ libgnome_keyring ];
  passthru.propagatedUserEnvPackages = [ glib_networking ];

  # glib_networking is a runtime dependency, not a compile-time dependency
  configureFlags = "--disable-tls-check";

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  meta = {
#    inherit (glib.meta) maintainers platforms;
  };
}
