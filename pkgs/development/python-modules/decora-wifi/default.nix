{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  inflect,
  setuptools,
}:

buildPythonPackage rec {
  pname = "decora_wifi";
  version = "1.4";
  pyproject = true;

  #No tag in github, so fetchPypi is OK to use.
  src = fetchPypi {
    pname = "decora_wifi";
    inherit version;
    hash = "sha256-BIQssxEpwCIyj5z0N2ev9cJr/y907g0Lb7h5iD9dApM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    inflect
  ];
  pythonImportsCheck = [ "decora_wifi" ];

  # No tests in Pypi source
  doCheck = false;

  meta = {
    description = "Python library for controlling Leviton Decora Smart Wi-Fi devices";
    homepage = "https://github.com/tlyakhov/python-decora_wifi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Continous ];
  };
}
