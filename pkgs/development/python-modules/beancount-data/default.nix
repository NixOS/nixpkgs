{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
}:

buildPythonPackage rec {
  pname = "beancount-data";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beancount-data";
    tag = version;
    hash = "sha256-X/TeL1+hwZRDsqg3RMCfq3WASM1fScU+odFwcaOzgXs=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pydantic ];

  pythonImportsCheck = [ "beancount_data" ];

  meta = {
    description = "Pydantic data models for exporting Beancount data";
    homepage = "https://github.com/LaunchPlatform/beancount-data";
    changelog = "https://github.com/LaunchPlatform/beancount-data/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
