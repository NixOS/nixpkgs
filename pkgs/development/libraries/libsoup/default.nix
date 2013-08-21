{ stdenv, fetchurl, glib, libxml2, pkgconfig
, gnomeSupport ? true, libgnome_keyring, sqlite, glib_networking
, libintlOrEmpty }:

stdenv.mkDerivation {
  name = "libsoup-2.38.1";

  src = fetchurl {
    url = mirror://gnome/sources/libsoup/2.38/libsoup-2.38.1.tar.xz;
    sha256 = "16iza4y8pmc4sn90iid88fgminvgcqypy3s2qnmzkzm5qwzr5f3i";
  };


  buildInputs = libintlOrEmpty;
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
