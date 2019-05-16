{ lib
, buildPythonPackage
, python
, pygobject3
, pyatspi
, pycairo
, at-spi2-core
, gobject-introspection
, gtk3
, gsettings-desktop-schemas
, fetchurl
, dbus
, xvfb_run
# , fetchPypi
}:

buildPythonPackage rec {
  pname = "dogtail";
  version = "0.9.10";

  # https://gitlab.com/dogtail/dogtail/issues/1
  # src = fetchPypi {
  #   inherit pname version;
  #   sha256 = "0p5wfssvzr9w0bvhllzbbd8fnp4cca2qxcpcsc33dchrmh5n552x";
  # };
  src = fetchurl {
    url = https://gitlab.com/dogtail/dogtail/raw/released/dogtail-0.9.10.tar.gz;
    sha256 = "14sycidl8ahj3fwlhpwlpnyd43c302yqr7nqg2hj39pyj7kgk15b";
  };

  patches = [
    ./nix-support.patch
  ];

  nativeBuildInputs = [ gobject-introspection dbus xvfb_run ]; # for setup hooks
  propagatedBuildInputs = [ at-spi2-core gtk3 pygobject3 pyatspi pycairo ];

  checkPhase = ''
    runHook preCheck
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:$XDG_DATA_DIRS
    # export NO_AT_BRIDGE=1
    gsettings set org.gnome.desktop.interface toolkit-accessibility true
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      ${python.interpreter} nix_run_setup test
    runHook postCheck
  '';

  # TODO: Tests require accessibility
  doCheck = false;

  meta = {
    description = "GUI test tool and automation framework that uses Accessibility technologies to communicate with desktop applications";
    homepage = https://gitlab.com/dogtail/dogtail;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ jtojnar ];
  };
}
