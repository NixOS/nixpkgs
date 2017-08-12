{ stdenv, fetchurl, glib, libxml2, pkgconfig
, gnomeSupport ? true, libgnome_keyring3, sqlite, glib_networking, gobjectIntrospection
, valaSupport ? true, vala_0_32
, libintlOrEmpty
, intltool, python }:
let
  majorVersion = "2.59";
  version = "${majorVersion}.90.1";
in
stdenv.mkDerivation {
  name = "libsoup-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsoup/${majorVersion}/libsoup-${version}.tar.xz";
    sha256 = "0bh8wa0szkm9bx2anfq655zshwf6jhxvrqwx8jyh8rqgi6z9dhz0";
  };

  prePatch = ''
    patchShebangs libsoup/
  '' + stdenv.lib.optionalString valaSupport
  ''
     substituteInPlace libsoup/Makefile.in --replace "\$(DESTDIR)\$(vapidir)" "\$(DESTDIR)\$(girdir)/../vala/vapi"
  '';

  outputs = [ "out" "dev" ];

  buildInputs = libintlOrEmpty ++ [ intltool python sqlite ]
    ++ stdenv.lib.optionals valaSupport [ vala_0_32 ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libxml2 gobjectIntrospection ]
    ++ stdenv.lib.optionals gnomeSupport [ libgnome_keyring3 ];
  passthru.propagatedUserEnvPackages = [ glib_networking.out ];

  # glib_networking is a runtime dependency, not a compile-time dependency
  configureFlags = "--disable-tls-check"
    + " --enable-vala=${if valaSupport then "yes" else "no"}"
    + stdenv.lib.optionalString (!gnomeSupport) " --without-gnome";

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = {
    inherit (glib.meta) maintainers platforms;
  };
}
