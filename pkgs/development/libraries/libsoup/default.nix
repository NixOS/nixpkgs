{ stdenv, fetchurl, glib, libxml2, pkgconfig
, gnomeSupport ? false, libgnome_keyring, sqlite, glib_networking, gobjectIntrospection
, libintlOrEmpty
, intltool, python }:
let
  majorVersion = "2.52";
  version = "${majorVersion}.2";
in
stdenv.mkDerivation {
  name = "libsoup-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsoup/${majorVersion}/libsoup-${version}.tar.xz";
    sha256 = "1p4k40y2gikr6m8p3hm0vswdzj2pj133dckipd2jk5bxbj5n4mfv";
  };

  patchPhase = ''
    patchShebangs libsoup/
  '';

  outputs = [ "dev" "out" ];

  buildInputs = libintlOrEmpty ++ [ intltool python sqlite ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libxml2 gobjectIntrospection ]
    ++ stdenv.lib.optionals gnomeSupport [ libgnome_keyring ];
  passthru.propagatedUserEnvPackages = [ glib_networking.out ];

  # glib_networking is a runtime dependency, not a compile-time dependency
  configureFlags = "--disable-tls-check --enable-vala=no" + stdenv.lib.optionalString (!gnomeSupport) " --without-gnome";

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = {
    inherit (glib.meta) maintainers platforms;
  };
}
