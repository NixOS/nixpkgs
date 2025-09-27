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
  setuptools,
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

  patchPhase = ''
    echo 'dependencies = [
      "gi",
      "pygobject3",
    ]' >> pyproject.toml
    cat pyproject.toml
  '';

  patches = [ ./nix-support.patch ];

  nativeBuildInputs = [
    gobject-introspection
    dbus
    xvfb-run
    wrapGAppsHook3
    setuptools
  ]; # for setup hooks
  propagatedBuildInputs = [
    at-spi2-core
    gtk3
    pygobject3
    pyatspi
    pycairo
  ];

  checkPhase = ''
    runHook preCheck
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:$XDG_DATA_DIRS
    # export NO_AT_BRIDGE=1
    gsettings set org.gnome.desktop.interface toolkit-accessibility true
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      ${python.interpreter} nix_run_setup test
    runHook postCheck
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # TODO: Tests require accessibility
  doCheck = false;

  meta = {
    description = "GUI test tool and automation framework that uses Accessibility technologies to communicate with desktop applications";
    homepage = "https://gitlab.com/dogtail/dogtail";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
