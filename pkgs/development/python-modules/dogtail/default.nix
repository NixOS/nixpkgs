{
  lib,
  buildPythonPackage,
  python3,
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
    gobject-introspection
    wrapGAppsHook3
    setuptools
  ];

  buildInputs = [
    gtk3
    glib
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  strictDeps = false; # broken with gobject-introspection setup hook https://github.com/NixOS/nixpkgs/issues/56943
  doCheck = false; # why?
  

  meta = {
    description = "GUI test tool and automation framework that uses Accessibility technologies to communicate with desktop applications";
    homepage = "https://gitlab.com/dogtail/dogtail";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
