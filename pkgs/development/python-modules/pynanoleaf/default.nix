{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynanoleaf";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MqCDdZxPmeAZ4AE2cEh4Qfjt+AfHoHdCqXH6GHBwcqc=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # pynanoleaf does not contain tests
  doCheck = false;

  pythonImportsCheck = [ "pynanoleaf" ];

  meta = with lib; {
    description = "Python3 wrapper for the Nanoleaf API, capable of controlling both Nanoleaf Aurora and Nanoleaf Canvas";
    homepage = "https://github.com/Oro/pynanoleaf";
    changelog = "https://github.com/Oro/pynanoleaf/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ oro ];
  };
}
