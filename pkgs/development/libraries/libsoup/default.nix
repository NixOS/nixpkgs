{ stdenv, fetchurl, glib, libxml2, pkgconfig
, gnomeSupport ? true, libgnome_keyring, sqlite, glib_networking }:

stdenv.mkDerivation {
  name = "libsoup-2.38.1";

  src = fetchurl {
    url = mirror://gnome/sources/libsoup/2.38/libsoup-2.38.1.tar.xz;
    sha256 = "16iza4y8pmc4sn90iid88fgminvgcqypy3s2qnmzkzm5qwzr5f3i";
  };


  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libxml2 ]
    ++ stdenv.lib.optionals gnomeSupport [ libgnome_keyring sqlite ];
  passthru.propagatedUserEnvPackages = [ glib_networking ];

  # glib_networking is a runtime dependency, not a compile-time dependency
  configureFlags = "--disable-tls-check";

  meta = {
    inherit (glib.meta) maintainers platforms;
  };
}
