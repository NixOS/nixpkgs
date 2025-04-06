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
  version = "1.5";
  pyproject = true;

  #No tag in github, so fetchPypi is OK to use.
  src = fetchPypi {
    pname = "decora_wifi";
    inherit version;
    hash = "sha256-oWETtzZueNJC0lTWdLfk3SOuvnqrJ9wp5rOSPJxH3M4=";
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
