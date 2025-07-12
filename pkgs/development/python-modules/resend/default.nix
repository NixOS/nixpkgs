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
  version = "2.10.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "resend";
    repo = "resend-python";
    tag = "v${version}";
    hash = "sha256-K/Wk1TZWurhSm3fIAijO+L1ao4pURnlthwxdkI6yZWM=";
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
