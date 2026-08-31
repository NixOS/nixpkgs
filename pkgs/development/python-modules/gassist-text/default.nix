{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  google-auth,
  grpcio,
  protobuf,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "gassist-text";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "gassist_text";
    tag = finalAttrs.version;
    hash = "sha256-KrlStBYsE8PwAH7C7WzLezLffBFcmj/1cA0YJq/hkkU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    google-auth
    grpcio
    protobuf
    requests
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gassist_text" ];

  meta = {
    description = "Module for interacting with Google Assistant API via text";
    homepage = "https://github.com/tronikos/gassist_text";
    changelog = "https://github.com/tronikos/gassist_text/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
