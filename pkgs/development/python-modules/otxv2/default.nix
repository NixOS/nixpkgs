{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  pytz,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "otxv2";
  version = "1.5.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AlienVault-OTX";
    repo = "OTX-Python-SDK";
    tag = version;
    hash = "sha256-JAjBXNsX0Cuni+4L6I1RuaSfors5cBAZ2krPLhIFluY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    pytz
    requests
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "OTXv2" ];

  meta = {
    description = "The Python SDK for AlienVault OTX";
    homepage = "https://github.com/AlienVault-OTX/OTX-Python-SDK";
    changelog = "https://github.com/AlienVault-OTX/OTX-Python-SDK/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
