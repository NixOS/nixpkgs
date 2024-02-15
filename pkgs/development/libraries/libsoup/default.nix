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
, gobject-introspection
, vala
, libpsl
, brotli
, gnomeSupport ? true
, sqlite
, buildPackages
, withIntrospection ? lib.meta.availableOn stdenv.hostPlatform gobject-introspection && stdenv.hostPlatform.emulatorAvailable buildPackages
}:

stdenv.mkDerivation rec {
  pname = "libsoup";
  version = "2.74.3";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-5Ld8Qc/EyMWgNfzcMgx7xs+3XvfFoDQVPfFBP6HZLxM=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
    vala
  ];

  buildInputs = [
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
    "-Dvapi=${if withIntrospection then "enabled" else "disabled"}"
    "-Dintrospection=${if withIntrospection then "enabled" else "disabled"}"
    "-Dgnome=${lib.boolToString gnomeSupport}"
    "-Dntlm=disabled"
  ] ++ lib.optionals (!stdenv.isLinux) [
    "-Dsysprof=disabled"
  ];

  env.NIX_CFLAGS_COMPILE = "-lpthread";

  doCheck = false; # ERROR:../tests/socket-test.c:37:do_unconnected_socket_test: assertion failed (res == SOUP_STATUS_OK): (2 == 200)
  separateDebugInfo = true;

  postPatch = ''
    # fixes finding vapigen when cross-compiling
    # the commit is in 3.0.6
    # https://gitlab.gnome.org/GNOME/libsoup/-/commit/5280e936d0a76f94dbc5d8489cfbdc0a06343f65
    substituteInPlace meson.build \
      --replace "required: vapi_opt)" "required: vapi_opt, native: false)"

    patchShebangs libsoup/
  '';

  passthru = {
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
    pkgConfigModules = [
      "libsoup-2.4"
      "libsoup-gnome-2.4"
    ];
  };
}
