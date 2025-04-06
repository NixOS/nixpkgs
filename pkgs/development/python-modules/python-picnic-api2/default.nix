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
  version = "1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codesalatdev";
    repo = "python-picnic-api";
    tag = "v${version}";
    hash = "sha256-vlb53f+k+oX9ycyTe/63u0qoqIn8kHKtCehl82Ks9wY=";
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
