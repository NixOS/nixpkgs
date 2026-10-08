{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "dbus-client-gen";
  version = "0.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vRXo72aWoreH/VwzdEAOgoGSRzRf7vy8Z/IA+lnLoWw=";
  };

  meta = {
    description = "Python Library for Generating D-Bus Client Code";
    homepage = "https://github.com/stratis-storage/dbus-client-gen";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
