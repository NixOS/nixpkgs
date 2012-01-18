{ stdenv, fetchurl, glib, libxml2, pkgconfig, xz
, gnomeSupport ? true, libgnome_keyring, sqlite, glib_networking }:

stdenv.mkDerivation {
  name = "libsoup-2.36.1";

  src = fetchurl {
    url = mirror://gnome/sources/libsoup/2.36/libsoup-2.36.1.tar.xz;
    sha256 = "0r8zkr0a328jkww4dv9z1q691rw59nh4lf5f5pzzr9szzw3j8wkk";
  };


  buildNativeInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libxml2 ]
    ++ stdenv.lib.optionals gnomeSupport [ libgnome_keyring sqlite ];
  passthru.propagatedUserEnvPackages = [ glib_networking ];

  # glib_networking is a runtime dependency, not a compile-time dependency
  configureFlags = "--disable-tls-check";

  meta = {
    inherit (glib.meta) maintainers platforms;
  };
}
