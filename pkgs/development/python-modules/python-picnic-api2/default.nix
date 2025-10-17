{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
  python-dotenv,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "python-picnic-api2";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codesalatdev";
    repo = "python-picnic-api";
    tag = "v${version}";
    hash = "sha256-GFxs2ZjyGADMG8YWtpy+sAZClLOYt70KtEp5MCgY+7I=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    typing-extensions
  ];

  pythonImportsCheck = [ "python_picnic_api2" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # tests access the actual API
    "integration_tests"
  ];

  meta = {
    changelog = "https://github.com/codesalatdev/python-picnic-api/releases/tag/${src.tag}";
    description = "Fork of the Unofficial Python wrapper for the Picnic API";
    homepage = "https://github.com/codesalatdev/python-picnic-api";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
