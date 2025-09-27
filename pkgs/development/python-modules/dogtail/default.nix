{
  lib,
  buildPythonPackage,
  python,
  pygobject3,
  pyatspi,
  pycairo,
  at-spi2-core,
  gobject-introspection,
  gtk3,
  gsettings-desktop-schemas,
  fetchurl,
  dbus,
  xvfb-run,
  wrapGAppsHook3,
  fetchPypi,
  gnome-ponytail-daemon,
  glib
}:

buildPythonPackage rec {
  pname = "dogtail";
  version = "1.0.7";
  format = "setuptools";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-VURwc8li710YRdEZcuIayVeSQEkN6CtON3C5qMOk+zs=";
  };

  nativeBuildInputs = [
    gobject-introspection
    dbus
    xvfb-run
    wrapGAppsHook3
    gsettings-desktop-schemas
    glib
  ];

  buildInputs = [
    gsettings-desktop-schemas
  ];

  propagatedBuildInputs = [
    at-spi2-core
    gtk3
    pygobject3
    pyatspi
    pycairo
    gnome-ponytail-daemon
    gsettings-desktop-schemas
  ];

  checkPhase = ''
    runHook preCheck
    export HOME=$(mktemp -d)
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:$XDG_DATA_DIRS
    gsettings set org.gnome.desktop.interface toolkit-accessibility true
    echo "<busconfig>
      <type>session</type>
      <listen>unix:tmpdir=$TMPDIR</listen>
      <listen>unix:path=/build/system_bus_socket</listen>
      <standard_session_servicedirs/>
      <policy context=\"default\">
        <!-- Allow everything to be sent -->
        <allow send_destination=\"*\" eavesdrop=\"true\"/>
        <!-- Allow everything to be received -->
        <allow eavesdrop=\"true\"/>
        <!-- Allow anyone to own anything -->
        <allow own=\"*\"/>
      </policy>
    </busconfig>" > dbus.cfg

    export PATH=${
        lib.makeBinPath (
          [
            dbus
          ]
        )
    }:$PATH
    export USER="$(id -u -n)"
    export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/build/system_bus_socket
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
       --config-file dbus.cfg \
      ${python.interpreter} -c 'from dogtail.tree import root, Node'
    runHook postCheck
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  doCheck = true;

  meta = {
    description = "GUI test tool and automation framework that uses Accessibility technologies to communicate with desktop applications";
    homepage = "https://gitlab.com/dogtail/dogtail";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
