{
  lib,
  fetchFromGitHub,
  python3Packages,
  intltool,
  mate,
  libnotify,
  gtk3,
  gdk-pixbuf,
  gobject-introspection,
  wrapGAppsHook3,
  glib,
  gitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "mate-tweak";
  version = "22.10.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ubuntu-mate";
    repo = "mate-tweak";
    rev = version;
    sha256 = "emeNgCzMhHMeLOyUkXe+8OzQMEWuwNdD4xkGXIFgbh4=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    intltool
    python3Packages.distutils-extra
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    gdk-pixbuf
    libnotify
    glib
    mate.mate-applets
    mate.mate-panel
    mate.marco
    mate.libmatekbd
    mate.mate-session-manager
  ];

  propagatedBuildInputs = with python3Packages; [
    distro
    pygobject3
    psutil
    setproctitle
  ];

  strictDeps = false;

  dontWrapGApps = true;

  postPatch = ''
    # mate-tweak hardcodes absolute paths everywhere. Nuke from orbit.
    find . -type f -exec sed -i \
      -e s,/usr/lib/mate-tweak,$out/lib/mate-tweak,g \
      {} +

    sed -i 's,{prefix}/,,g' setup.py
  '';

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    for i in bin/.mate-tweak-wrapped lib/mate-tweak/mate-tweak-helper; do
      sed -i "s,usr,run/current-system/sw,g" $out/$i
    done
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Tweak tool for the MATE Desktop";
    homepage = "https://github.com/ubuntu-mate/mate-tweak";
    changelog = "https://github.com/ubuntu-mate/mate-tweak/releases/tag/${version}";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.linux;
    teams = [ teams.mate ];
  };
}
