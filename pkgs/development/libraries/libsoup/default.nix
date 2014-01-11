{ stdenv, fetchurl, glib, libxml2, pkgconfig
, gnomeSupport ? true, libgnome_keyring, sqlite, glib_networking
, libintlOrEmpty
, intltool, python }:

stdenv.mkDerivation {
  name = "libsoup-2.45";
  version = "2.45";

  src = fetchurl {
    url = mirror://gnome/sources/libsoup/2.45/libsoup-2.45.3.tar.xz;
    sha256 = "04ma47hcrrbjp90r8jjn686cngnbgac24wgarpwwzlpg66wighva";
  };

  buildInputs = libintlOrEmpty ++ [ intltool python ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libxml2 ]
    ++ stdenv.lib.optionals gnomeSupport [ libgnome_keyring sqlite ];
  passthru.propagatedUserEnvPackages = [ glib_networking ];

  # glib_networking is a runtime dependency, not a compile-time dependency
  configureFlags = "--disable-tls-check";

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  meta = {
    inherit (glib.meta) maintainers platforms;
  };
}
