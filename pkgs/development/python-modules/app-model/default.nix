{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  in-n-out,
  psygnal,
  pydantic,
  pydantic-compat,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "app-model";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = "app-model";
    tag = "v${version}";
    hash = "sha256-zKaCxozT6OOPfrXMDic5d5DMb/I9tTiJFlX21Cc1yjY=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    psygnal
    pydantic
    pydantic-compat
    in-n-out
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "app_model" ];

  meta = with lib; {
    description = "Module to implement generic application schema";
    homepage = "https://github.com/pyapp-kit/app-model";
    changelog = "https://github.com/pyapp-kit/app-model/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
