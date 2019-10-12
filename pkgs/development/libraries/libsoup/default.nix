{ stdenv, fetchurl, glib, libxml2, meson, ninja, pkgconfig, gnome3
, gnomeSupport ? true, sqlite, glib-networking, gobject-introspection, vala
, libpsl, python3 }:

stdenv.mkDerivation rec {
  pname = "libsoup";
  version = "2.66.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0yc749ismwgkm61crc0iv0drhbdjn9iig71s2664y77f3r7rh243";
  };

  postPatch = ''
    patchShebangs libsoup/
  '';

  outputs = [ "out" "dev" ];

  buildInputs = [ python3 sqlite libpsl ];
  nativeBuildInputs = [ meson ninja pkgconfig gobject-introspection vala ];
  propagatedBuildInputs = [ glib libxml2 ];

  mesonFlags = [
    "-Dtls_check=false" # glib-networking is a runtime dependency, not a compile-time dependency
    "-Dgssapi=false"
    "-Dvapi=true"
    "-Dgnome=${if gnomeSupport then "true" else "false"}"
  ];

  doCheck = false; # ERROR:../tests/socket-test.c:37:do_unconnected_socket_test: assertion failed (res == SOUP_STATUS_OK): (2 == 200)

  passthru = {
    propagatedUserEnvPackages = [ glib-networking.out ];
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "HTTP client/server library for GNOME";
    homepage = https://wiki.gnome.org/Projects/libsoup;
    license = stdenv.lib.licenses.gpl2;
    inherit (glib.meta) maintainers platforms;
  };
}
