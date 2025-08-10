{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymicrobot";
  version = "0.0.23";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fRCXCT3DR42HhYom23hVcWBXFngLPn7UZmyKrjb+MNY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "microbot" ];

  meta = with lib; {
    description = "Library to communicate with MicroBot";
    homepage = "https://github.com/spycle/pyMicroBot/";
    changelog = "https://github.com/spycle/pyMicroBot/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
