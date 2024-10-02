{ stdenv
, lib
, fetchurl
, glib
, meson
, ninja
, pkg-config
, gnome
, libsysprof-capture
, sqlite
, buildPackages
, gobject-introspection
, withIntrospection ? lib.meta.availableOn stdenv.hostPlatform gobject-introspection && stdenv.hostPlatform.emulatorAvailable buildPackages
, vala
, libpsl
, python3
, gi-docgen
, brotli
, libnghttp2
}:

stdenv.mkDerivation rec {
  pname = "libsoup";
  version = "3.4.4";

  outputs = [ "out" "dev" ] ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-KRxncl827ZDqQ+//JQZLacWi0ZgUiEd8BcSBo7Swxao=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
    python3
  ] ++ lib.optionals withIntrospection [
    gi-docgen
    gobject-introspection
    vala
  ];

  buildInputs = [
    sqlite
    libpsl
    glib.out
    brotli
    libnghttp2
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    libsysprof-capture
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dtls_check=false" # glib-networking is a runtime dependency, not a compile-time dependency
    "-Dgssapi=disabled"
    "-Dntlm=disabled"
    # Requires wstest from autobahn-testsuite.
    "-Dautobahn=disabled"
    # Requires gnutls, not added for closure size.
    "-Dpkcs11_tests=disabled"

    (lib.mesonEnable "docs" withIntrospection)
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonEnable "sysprof" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "vapi" withIntrospection)
  ];

  # TODO: For some reason the pkg-config setup hook does not pick this up.
  PKG_CONFIG_PATH = "${libnghttp2.dev}/lib/pkgconfig";

  # HSTS tests fail.
  doCheck = false;
  separateDebugInfo = true;

  postPatch = ''
    patchShebangs libsoup/
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "libsoup_3";
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "HTTP client/server library for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/libsoup";
    license = lib.licenses.lgpl2Plus;
    inherit (glib.meta) maintainers platforms;
  };
}
