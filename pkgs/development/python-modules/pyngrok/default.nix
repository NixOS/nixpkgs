{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pyngrok";
  version = "7.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8iQOSbneybJ+ugDxREzTzOesRdG8xJOpt27mPC2piCw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
  ];

  pythonImportsCheck = [ "pyngrok" ];

  meta = {
    description = "Python wrapper for ngrok";
    homepage = "https://github.com/alexdlaird/pyngrok";
    changelog = "https://github.com/alexdlaird/pyngrok/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
