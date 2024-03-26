{ lib
, aiofiles
, buildPythonPackage
, colorama
, fetchFromGitHub
, git
, jsonschema
, pdm-backend
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "griffe";
  version = "0.42.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "griffe";
    rev = "refs/tags/${version}";
    hash = "sha256-KaD3j96FJJx43m/nfHa4kAft4FcDOdq+2dsiaMY7PPY=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    colorama
  ];

  nativeCheckInputs = [
    git
    jsonschema
    pytestCheckHook
  ];

  passthru.optional-dependencies = {
    async = [
      aiofiles
    ];
  };

  pythonImportsCheck = [
    "griffe"
  ];

  meta = with lib; {
    description = "Signatures for entire Python programs";
    mainProgram = "griffe";
    homepage = "https://github.com/mkdocstrings/griffe";
    changelog = "https://github.com/mkdocstrings/griffe/blob/${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
