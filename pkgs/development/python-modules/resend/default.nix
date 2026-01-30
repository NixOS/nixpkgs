{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "resend";
  version = "2.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "resend";
    repo = "resend-python";
    tag = "v${version}";
    hash = "sha256-/y4BvaF6Qknje6bWQWm9sfJQMAnOjOJdmsePVC+ZKmI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "resend" ];

  meta = {
    description = "SDK for Resend";
    homepage = "https://github.com/resend/resend-python";
    changelog = "https://github.com/resend/resend-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
