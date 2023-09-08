{ lib
, stdenv
, docbook-xsl-nons
, fetchFromGitLab
, glib
, gobject-introspection
, gtk-doc
, libsoup_3
, meson
, mesonEmulatorHook
, ninja
, pkg-config
, vala
}:

stdenv.mkDerivation rec {
  pname = "uhttpmock";
  version = "0.9.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pwithnall";
    repo = "uhttpmock";
    rev = version;
    hash = "sha256-9GfFvH/rAUPIQp9ZdagTnCOE+7/xbcTTZkXTstnFZyU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gtk-doc
    docbook-xsl-nons
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    libsoup_3
  ];

  meta = with lib; {
    description = "Project for mocking web service APIs which use HTTP or HTTPS";
    homepage = "https://gitlab.freedesktop.org/pwithnall/uhttpmock/";
    changelog = "https://gitlab.freedesktop.org/pwithnall/uhttpmock/-/blob/${version}/NEWS";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
