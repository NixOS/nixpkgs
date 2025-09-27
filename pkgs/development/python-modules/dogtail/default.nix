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
  wrapGAppsHook,
  fetchPypi,
  gnome-ponytail-daemon,
  glib,
  setuptools
}:

buildPythonPackage rec {
  pname = "dogtail";
  version = "1.0.7";
  pyproject = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-VURwc8li710YRdEZcuIayVeSQEkN6CtON3C5qMOk+zs=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
    glib
    gtk3
    setuptools
  ];

  buildInputs = [
    gobject-introspection
    glib
    gtk3
  ];

  propagatedBuildInputs = [
    gobject-introspection
    pygobject3
  ];

  dependencies = [
    at-spi2-core
    pygobject3
    pyatspi
    pycairo
  ];

  # Prevent double wrapping.
  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  doCheck = false;

  strictDeps = false;

  meta = {
    description = "GUI test tool and automation framework that uses Accessibility technologies to communicate with desktop applications";
    homepage = "https://gitlab.com/dogtail/dogtail";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
