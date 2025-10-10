{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  typing-extensions,
  uv-build,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sigstore-models";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "sigstore-models";
    tag = "v${version}";
    hash = "sha256-zlIZzfgHZPEuiZu3JNX74Cg1jPNaO1HUhMtpxoyOoqk=";
  };

  build-system = [ uv-build ];

  dependencies = [
    pydantic
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigstore_models" ];

  meta = {
    description = "Pydantic-based, protobuf-free data models for Sigstore";
    homepage = "https://github.com/astral-sh/sigstore-models";
    changelog = "https://github.com/astral-sh/sigstore-models/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
