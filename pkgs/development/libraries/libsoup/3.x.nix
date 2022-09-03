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
, glib-networking
, gobject-introspection
, withIntrospection ? stdenv.buildPlatform == stdenv.hostPlatform
, vala
, withVala ? stdenv.buildPlatform == stdenv.hostPlatform
, libpsl
, python3
, gi-docgen
, brotli
, libnghttp2
}:

stdenv.mkDerivation rec {
  pname = "libsoup";
  version = "3.1.4";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-BBWZP8mXRrsPypVJAEqCgICxuTYhNUDyl8KQBZVwtVQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
    python3
    gi-docgen
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
  ] ++ lib.optionals withVala [
    vala
  ];

  buildInputs = [
    sqlite
    libpsl
    glib.out
    brotli
    libnghttp2
  ] ++ lib.optionals stdenv.isLinux [
    libsysprof-capture
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dtls_check=false" # glib-networking is a runtime dependency, not a compile-time dependency
    "-Dgssapi=disabled"
    "-Dvapi=${if withVala then "enabled" else "disabled"}"
    "-Dintrospection=${if withIntrospection then "enabled" else "disabled"}"
    "-Dntlm=disabled"
    # Requires wstest from autobahn-testsuite.
    "-Dautobahn=disabled"
    # Requires gnutls, not added for closure size.
    "-Dpkcs11_tests=disabled"
  ] ++ lib.optionals (!stdenv.isLinux) [
    "-Dsysprof=disabled"
  ];

  # TODO: For some reason the pkg-config setup hook does not pick this up.
  PKG_CONFIG_PATH = "${libnghttp2.dev}/lib/pkgconfig";

  # HSTS tests fail.
  doCheck = false;

  postPatch = ''
    patchShebangs libsoup/
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    propagatedUserEnvPackages = [
      glib-networking.out
    ];
    updateScript = gnome.updateScript {
      attrPath = "libsoup_3";
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
