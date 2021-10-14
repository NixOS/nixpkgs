{ stdenv
, lib
, fetchurl
, glib
, libxml2
, meson
, ninja
, pkg-config
, gnome
, libsysprof-capture
, gnomeSupport ? true
, sqlite
, glib-networking
, gobject-introspection
, withIntrospection ? stdenv.buildPlatform == stdenv.hostPlatform
, vala
, withVala ? stdenv.buildPlatform == stdenv.hostPlatform
, libpsl
, python3
, brotli
}:

stdenv.mkDerivation rec {
  pname = "libsoup";
  version = "2.74.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-M7HU4NY5RWxnXCJ4d+lKgHjXMSM+LVdonBGrzvfTxI4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
  ] ++ lib.optionals withVala [
    vala
  ];

  buildInputs = [
    python3
    sqlite
    libpsl
    glib.out
    brotli
  ] ++ lib.optionals stdenv.isLinux [
    libsysprof-capture
  ];

  propagatedBuildInputs = [
    glib
    libxml2
  ];

  mesonFlags = [
    "-Dtls_check=false" # glib-networking is a runtime dependency, not a compile-time dependency
    "-Dgssapi=disabled"
    "-Dvapi=${if withVala then "enabled" else "disabled"}"
    "-Dintrospection=${if withIntrospection then "enabled" else "disabled"}"
    "-Dgnome=${lib.boolToString gnomeSupport}"
    "-Dntlm=disabled"
  ] ++ lib.optionals (!stdenv.isLinux) [
    "-Dsysprof=disabled"
  ];

  NIX_CFLAGS_COMPILE = "-lpthread";

  doCheck = false; # ERROR:../tests/socket-test.c:37:do_unconnected_socket_test: assertion failed (res == SOUP_STATUS_OK): (2 == 200)

  postPatch = ''
    patchShebangs libsoup/
  '';

  passthru = {
    propagatedUserEnvPackages = [
      glib-networking.out
    ];
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = {
    description = "HTTP client/server library for GNOME";
    homepage = "https://wiki.gnome.org/Projects/libsoup";
    license = lib.licenses.lgpl2Plus;
    inherit (glib.meta) maintainers platforms;
  };
}
