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

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  doCheck = true;

  installCheckPhase = ''
    export HOME=$(mktemp -d)
  '';

  XDG_DATA_DIRS = "${gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-48.0/";

  #checkPhase = ''
  #  python -c 'from dogtail.tree import root, Node'
  #'';

  pythonImportsCheck = [ "dogtail.tree" ];

  meta = {
    description = "GUI test tool and automation framework that uses Accessibility technologies to communicate with desktop applications";
    homepage = "https://gitlab.com/dogtail/dogtail";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
