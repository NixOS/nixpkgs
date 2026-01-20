{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rachiopy";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rfverbruggen";
    repo = "rachiopy";
    tag = version;
    hash = "sha256-PsdEXNy8vUxba/C00ARhLTQU9gMlChy9XdU20r+Maus=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    jsonschema
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rachiopy" ];

  meta = {
    description = "Python client for Rachio Irrigation controller";
    homepage = "https://github.com/rfverbruggen/rachiopy";
    changelog = "https://github.com/rfverbruggen/rachiopy/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
