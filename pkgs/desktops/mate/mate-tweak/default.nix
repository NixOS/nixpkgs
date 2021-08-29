{ lib
, fetchFromGitHub
, python3Packages
, intltool
, mate
, libnotify
, gtk3
, gdk-pixbuf
, gobject-introspection
, wrapGAppsHook
, glib
, genericUpdater
, common-updater-scripts
}:

python3Packages.buildPythonApplication rec {
  pname = "mate-tweak";
  version = "21.04.3";

  src = fetchFromGitHub {
    owner = "ubuntu-mate";
    repo = pname;
    rev = version;
    sha256 = "0vpzy7awhb1xfsdjsrchy5b9dygj4ixdcvgx5v5w8hllmi4yxpc1";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    intltool
    python3Packages.distutils_extra
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

  passthru.updateScript = genericUpdater {
    inherit pname version;
    attrPath = "mate.${pname}";
    versionLister = "${common-updater-scripts}/bin/list-git-tags ${src.meta.homepage}";
  };

  meta = with lib; {
    description = "Tweak tool for the MATE Desktop";
    homepage = "https://github.com/ubuntu-mate/mate-tweak";
    changelog = "https://github.com/ubuntu-mate/mate-tweak/releases/tag/${version}";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ luc65r ];
  };
}
