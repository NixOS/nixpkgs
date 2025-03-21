{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytestCheckHook,
  python-dotenv,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "python-picnic-api2";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codesalatdev";
    repo = "python-picnic-api";
    tag = "v${version}";
    hash = "sha256-pO0aIdMKSC8AT/Bu5axl1NZbbF8IM/cOygLRT8eRKlU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    requests
    typing-extensions
  ];

  pythonImportsCheck = [ "python_picnic_api2" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tests access the actual API
    "integration_tests"
  ];

  disabledTests = [
    # tests don't expect requests to come with the br transfer-encoding
    "test_update_auth_token"
  ];

  meta = {
    changelog = "https://github.com/codesalatdev/python-picnic-api/releases/tag/${src.tag}";
    description = "Fork of the Unofficial Python wrapper for the Picnic API";
    homepage = "https://github.com/codesalatdev/python-picnic-api";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
