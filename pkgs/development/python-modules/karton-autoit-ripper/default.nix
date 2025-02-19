{
  lib,
  autoit-ripper,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  karton-core,
  malduck,
  pythonOlder,
  regex,
}:

buildPythonPackage rec {
  pname = "karton-autoit-ripper";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton-autoit-ripper";
    tag = "v${version}";
    hash = "sha256-D+M3JsIN8LUWg8GVweEzySHI7KaBb6cNHHn4pXoq55M=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "autoit-ripper"
    "malduck"
    "regex"
  ];

  dependencies = [
    autoit-ripper
    karton-core
    malduck
    regex
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "karton.autoit_ripper" ];

  meta = with lib; {
    description = "AutoIt script ripper for Karton framework";
    mainProgram = "karton-autoit-ripper";
    homepage = "https://github.com/CERT-Polska/karton-autoit-ripper";
    changelog = "https://github.com/CERT-Polska/karton-autoit-ripper/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
