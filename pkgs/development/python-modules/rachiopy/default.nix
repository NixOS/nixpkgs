{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rachiopy";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

<<<<<<< HEAD
  meta = {
    description = "Python client for Rachio Irrigation controller";
    homepage = "https://github.com/rfverbruggen/rachiopy";
    changelog = "https://github.com/rfverbruggen/rachiopy/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python client for Rachio Irrigation controller";
    homepage = "https://github.com/rfverbruggen/rachiopy";
    changelog = "https://github.com/rfverbruggen/rachiopy/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
