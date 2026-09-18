{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "dbus-client-gen";
  version = "0.5.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-vRXo72aWoreH/VwzdEAOgoGSRzRf7vy8Z/IA+lnLoWw=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "dbus_client_gen" ];

  meta = {
    description = "Python Library for Generating D-Bus Client Code";
    homepage = "https://github.com/stratis-storage/dbus-client-gen";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
