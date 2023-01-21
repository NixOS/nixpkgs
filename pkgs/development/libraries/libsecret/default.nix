{ stdenv
, lib
, fetchurl
, glib
, meson
, ninja
, pkg-config
, gettext
, libxslt
, python3
, docbook-xsl-nons
, docbook_xml_dtd_42
, libgcrypt
, gobject-introspection
, vala
, gi-docgen
, gnome
, gjs
, libintl
, dbus
}:

stdenv.mkDerivation rec {
  pname = "libsecret";
  version = "0.20.5";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "P7PONA/NfbVNh8iT5pv8Kx9uTUsnkGX/5m2snw/RK00=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxslt # for xsltproc for building man pages
    docbook-xsl-nons
    docbook_xml_dtd_42
    libintl
    gobject-introspection
    vala
    gi-docgen
    glib
  ];

  buildInputs = [
    libgcrypt
    gobject-introspection
  ];

  propagatedBuildInputs = [
    glib
  ];

  nativeCheckInputs = [
    python3
    python3.pkgs.dbus-python
    python3.pkgs.pygobject3
    dbus
    gjs
  ];

  doCheck = stdenv.isLinux;

  postPatch = ''
    patchShebangs ./tool/test-*.sh
  '';

  preCheck = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overwitten during installation.
    mkdir -p $out/lib $out/lib
    ln -s "$PWD/libsecret/libmock-service.so" "$out/lib/libmock-service.so"
    ln -s "$PWD/libsecret/libsecret-1.so.0" "$out/lib/libsecret-1.so.0"
  '';

  checkPhase = ''
    runHook preCheck

    dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --print-errorlogs

    runHook postCheck
  '';

  postCheck = ''
    # This is test-only so it won’t be overwritten during installation.
    rm "$out/lib/libmock-service.so"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      # Does not seem to use the odd-unstable policy: https://gitlab.gnome.org/GNOME/libsecret/issues/30
      versionPolicy = "none";
    };
  };

  meta = {
    description = "A library for storing and retrieving passwords and other secrets";
    homepage = "https://wiki.gnome.org/Projects/Libsecret";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "secret-tool";
    inherit (glib.meta) platforms maintainers;
  };
}
