{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "openerz-api";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "misialq";
    repo = "openerz-api";
    tag = "v${version}";
    hash = "sha256-CwK61StspZJt0TALv76zfibUzlriwp9HRoYOtX9bU+c=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    testfixtures
  ];

  pythonImportsCheck = [ "openerz_api" ];

  meta = {
    description = "Python module to interact with the OpenERZ API";
    homepage = "https://github.com/misialq/openerz-api";
    changelog = "https://github.com/misialq/openerz-api/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
