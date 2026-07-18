{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "resend";
  version = "2.32.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "resend";
    repo = "resend-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wxro1Dgk7/ziPy2Z09teCyk99rxkDNODtlOugJDMUO0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "resend" ];

  meta = {
    description = "SDK for Resend";
    homepage = "https://github.com/resend/resend-python";
    changelog = "https://github.com/resend/resend-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
