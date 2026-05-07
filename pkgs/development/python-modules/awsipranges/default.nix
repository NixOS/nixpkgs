{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyopenssl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "awsipranges";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws-samples";
    repo = "awsipranges";
    tag = version;
    hash = "sha256-ve1+0zkDDUGswtQoXhfESMcBzoNgUutxEhz43HXL4H8=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pyopenssl
    pytestCheckHook
  ];

  pythonImportsCheck = [ "awsipranges" ];

  disabledTestPaths = [
    # Tests require network access
    "tests/data/test_syntax_and_semantics.py"
    "tests/integration/test_package_apis.py"
    "tests/unit/test_data_loading.py"
  ];

  meta = {
    description = "Module to work with the AWS IP address ranges";
    homepage = "https://github.com/aws-samples/awsipranges";
    changelog = "https://github.com/aws-samples/awsipranges/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
