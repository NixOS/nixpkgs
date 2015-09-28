{ stdenv, fetchurl, glib, libxml2, pkgconfig
, gnomeSupport ? false, libgnome_keyring, sqlite, glib_networking, gobjectIntrospection
, libintlOrEmpty
, intltool, python }:
let
  majorVersion = "2.50";
  version = "${majorVersion}.0";
in
stdenv.mkDerivation {
  name = "libsoup-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsoup/${majorVersion}/libsoup-${version}.tar.xz";
    sha256 = "1e01365ac4af3817187ea847f9d3588c27eee01fc519a5a7cb212bb78b0f667b";
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

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = {
    inherit (glib.meta) maintainers platforms;
  };
}
