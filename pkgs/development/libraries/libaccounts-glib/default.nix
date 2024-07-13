{ lib, stdenv, fetchFromGitLab, gitUpdater, meson, mesonEmulatorHook, ninja, glib, check, python3, vala, gtk-doc, glibcLocales
, libxml2, libxslt, pkg-config, sqlite, docbook_xsl, docbook_xml_dtd_43, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "libaccounts-glib";
  version = "1.27";

  outputs = [ "out" "dev" "devdoc" "py" ];

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "libaccounts-glib";
    rev = "VERSION_${version}";
    sha256 = "sha256-mLhcwp8rhCGSB1K6rTWT0tuiINzgwULwXINfCbgPKEg=";
  };

  nativeBuildInputs = [
    check
    docbook_xml_dtd_43
    docbook_xsl
    glibcLocales
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    vala
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    libxml2
    libxslt
    python3.pkgs.pygobject3
    sqlite
  ];

  # TODO: send patch upstream to make running tests optional
  postPatch = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace meson.build \
      --replace "subdir('tests')" ""
  '';

  LC_ALL = "en_US.UTF-8";

  mesonFlags = [
    "-Dinstall-py-overrides=true"
    "-Dpy-overrides-dir=${placeholder "py"}/${python3.sitePackages}/gi/overrides"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "VERSION_";
  };

  meta = with lib; {
    description = "Library for managing accounts which can be used from GLib applications";
    homepage = "https://gitlab.com/accounts-sso/libaccounts-glib";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
