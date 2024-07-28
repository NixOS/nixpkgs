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
# , fetchPypi
}:

buildPythonPackage {
  pname = "dogtail";
  version = "0.9.11";
  format = "setuptools";

  outputs = [
    "out"
    "dev"
  ];

  # https://gitlab.com/dogtail/dogtail/issues/1
  # src = fetchPypi {
  #   inherit pname version;
  #   sha256 = "0p5wfssvzr9w0bvhllzbbd8fnp4cca2qxcpcsc33dchrmh5n552x";
  # };
  src = fetchurl {
    url = "https://gitlab.com/dogtail/dogtail/raw/released/dogtail-0.9.10.tar.gz";
    sha256 = "EGyxYopupfXPYtTL9mm9ujZorvh8AGaNXVKBPWsGy3c=";
  };

  patches = [ ./nix-support.patch ];

  nativeBuildInputs = [
    gobject-introspection
    dbus
    xvfb-run
    wrapGAppsHook3
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
