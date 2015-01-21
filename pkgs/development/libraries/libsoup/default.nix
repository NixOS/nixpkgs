{ stdenv, fetchurl, glib, libxml2, pkgconfig
, gnomeSupport ? true, libgnome_keyring, sqlite, glib_networking, gobjectIntrospection
, libintlOrEmpty
, intltool, python }:
let
  majorVersion = "2.48";
  version = "${majorVersion}.0";
in
stdenv.mkDerivation {
  name = "libsoup-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsoup/${majorVersion}/libsoup-${version}.tar.xz";
    sha256 = "ea34dd64fe44343445daf6dd690d0691e9d973468de44878da97371c16d89784";
  };

  patchPhase = ''
    patchShebangs libsoup/
  '';

  buildInputs = libintlOrEmpty ++ [ intltool python sqlite ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libxml2 gobjectIntrospection ]
    ++ stdenv.lib.optionals gnomeSupport [ libgnome_keyring ];
  passthru.propagatedUserEnvPackages = [ glib_networking ];

  # glib_networking is a runtime dependency, not a compile-time dependency
  configureFlags = "--disable-tls-check" + stdenv.lib.optionalString (!gnomeSupport) " --without-gnome";

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  meta = {
    inherit (glib.meta) maintainers platforms;
  };
}
