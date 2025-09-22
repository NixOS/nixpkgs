{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  pytestCheckHook,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "resend";
  version = "2.13.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "resend";
    repo = "resend-python";
    tag = "v${version}";
    hash = "sha256-TE0sfNg6m71Chl6TPAssEiX+jeeHv0ZYOcv/HOe30OM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "resend" ];

  meta = with lib; {
    description = "SDK for Resend";
    homepage = "https://github.com/resend/resend-python";
    changelog = "https://github.com/resend/resend-python/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
