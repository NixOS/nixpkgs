{
  buildPythonPackage,
  fetchFromGitHub,
  google-auth,
  httpx,
  lib,
  pydantic,
  pytestCheckHook,
  requests,
  setuptools,
  typing-extensions,
  websockets,
}:

buildPythonPackage rec {
  pname = "google-genai";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-genai";
    tag = "v${version}";
    hash = "sha256-HXLo4dmlZNXXXpchO5sRlBzzQBU4cFS5qDpka2NdLTM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-auth
    httpx
    pydantic
    requests
    typing-extensions
    websockets
  ];

  pythonImportsCheck = [ "google.genai" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # ValueError: GOOGLE_GENAI_REPLAYS_DIRECTORY environment variable is not set
  doCheck = false;

  meta = {
    changelog = "https://github.com/googleapis/python-genai/blob/${src.tag}/CHANGELOG.md";
    description = "Google Generative AI Python SDK";
    homepage = "https://github.com/googleapis/python-genai";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
