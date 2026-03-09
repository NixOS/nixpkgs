{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  dbus-next,
  unidecode,
  tunit,

  # meta
  music-assistant,
}:

buildPythonPackage (finalAttrs: {
  pname = "mpris-api";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "mpris-api";
    inherit (finalAttrs) version;
    hash = "sha256-Xss74nrPlJh0Ik8tkZ5nG7GLYQd/vWl+nu/uYZ0Cyuc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dbus-next
    unidecode
    tunit
  ];

  pythonImportsCheck = [
    "mpris_api"
  ];

  meta = {
    description = "Make your multimedia app discoverable by linux desktop.";
    homepage = "https://bitbucket.org/massultidev/mpris-api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fooker ];
  };
})
