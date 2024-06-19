{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pretend,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "id";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "di";
    repo = "id";
    rev = "refs/tags/v${version}";
    hash = "sha256-lmUBy0hJAxfF65RcBP7tTizrg8j2Zypu4sKgOUQCYh8=";
  };

  build-system = [ flit-core ];

  dependencies = [
    pydantic
    requests
  ];

  nativeCheckInputs = [
    pretend
    pytestCheckHook
  ];

  pythonImportsCheck = [ "id" ];

  meta = with lib; {
    description = "A tool for generating OIDC identities";
    homepage = "https://github.com/di/id";
    changelog = "https://github.com/di/id/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
