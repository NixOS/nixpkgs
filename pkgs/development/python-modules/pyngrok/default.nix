{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pyngrok";
  version = "7.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rYY3c4ztW9uIwosIf+o5ylUoYMLTAASsAQM8D460824=";
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
