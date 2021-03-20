{ stdenv, lib, fetchurl, glib, libxml2, meson, ninja, pkg-config, gnome3, libsysprof-capture
, gnomeSupport ? true, sqlite, glib-networking, gobject-introspection, vala
, libpsl, python3, brotli
}:

stdenv.mkDerivation rec {
  pname = "libsoup";
  version = "2.72.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "11skbyw2pw32178q3h8pi7xqa41b2x4k6q4k9f75zxmh8s23y30p";
  };

  postPatch = ''
    patchShebangs libsoup/
  '';

  outputs = [ "out" "dev" ];

  buildInputs = [
    python3
    sqlite
    libpsl
    glib.out
    brotli
  ] ++ lib.optionals stdenv.isLinux [
    libsysprof-capture
  ];
  nativeBuildInputs = [ meson ninja pkg-config gobject-introspection vala glib ];
  propagatedBuildInputs = [ glib libxml2 ];

  NIX_CFLAGS_COMPILE = [ "-lpthread" ];

  mesonFlags = [
    "-Dtls_check=false" # glib-networking is a runtime dependency, not a compile-time dependency
    "-Dgssapi=disabled"
    "-Dvapi=enabled"
    "-Dgnome=${lib.boolToString gnomeSupport}"
    "-Dntlm=disabled"
  ] ++ lib.optionals (!stdenv.isLinux) [
    "-Dsysprof=disabled"
  ];

  doCheck = false; # ERROR:../tests/socket-test.c:37:do_unconnected_socket_test: assertion failed (res == SOUP_STATUS_OK): (2 == 200)

  passthru = {
    propagatedUserEnvPackages = [ glib-networking.out ];
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "HTTP client/server library for GNOME";
    homepage = "https://wiki.gnome.org/Projects/libsoup";
    license = lib.licenses.lgpl2Plus;
    inherit (glib.meta) maintainers platforms;
  };
}
