{ fetchFromGitHub
, lib
, gobject-introspection
, meson
, ninja
, python3
, gtk3
, gdk-pixbuf
, wrapGAppsHook
, gettext
, polkit
, glib
, gitUpdater
}:

python3.pkgs.buildPythonApplication rec  {
  pname = "warpinator";
  version = "1.4.5";

  format = "other";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-5mMV4WinpFR9ihgoQsgIXre0VpBdg9S8GjSkx+7ocLg=";
  };

  patches = [
    # See https://www.openwall.com/lists/oss-security/2023/04/26/1. Manually adjusted from
    # https://github.com/linuxmint/warpinator/commit/9aae768522b7bbb09c836419893802a02221d663.
    ./CVE-2023-29380.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    wrapGAppsHook
    gettext
    polkit # for its gettext
  ];

  buildInputs = [
    glib
    gtk3
    gdk-pixbuf
  ];

  propagatedBuildInputs = with python3.pkgs; [
    grpcio-tools
    protobuf
    pygobject3
    setproctitle
    xapp
    zeroconf
    grpcio
    setuptools
    cryptography
    pynacl
    netifaces
  ];

  mesonFlags = [
    "-Dbundle-zeroconf=false"
  ];

  postPatch = ''
    chmod +x install-scripts/*
    patchShebangs .

    find . -type f -exec sed -i \
      -e s,/usr/libexec/warpinator,$out/libexec/warpinator,g \
      {} +
  '';

  preFixup = ''
    # these get loaded via import from bin, so don't need wrapping
    chmod -x+X $out/libexec/warpinator/*.py
  '';

  passthru.updateScript = gitUpdater {
    ignoredVersions = "^master.*";
  };

  meta = with lib; {
    homepage = "https://github.com/linuxmint/warpinator";
    description = "Share files across the LAN";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
