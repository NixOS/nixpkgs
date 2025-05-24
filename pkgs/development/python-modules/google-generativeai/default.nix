{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-ai-generativelanguage,
  google-api-core,
  google-api-python-client,
  google-auth,
  protobuf,
  pydantic,
  pythonOlder,
  setuptools,
  tqdm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "google-generativeai";
  version = "0.8.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "google";
    repo = "generative-ai-python";
    tag = "v${version}";
    hash = "sha256-wc35JSc98xvepI7Gpe5jSJ+c8n7WLKa96axoWVcH7UM=";
  };

  pythonRelaxDeps = [ "google-ai-generativelanguage" ];

  build-system = [ setuptools ];

  dependencies = [
    google-ai-generativelanguage
    google-api-core
    google-api-python-client
    google-auth
    protobuf
    pydantic
    tqdm
    typing-extensions
  ];

  # Issue with the google.ai module. Check with the next release
  doCheck = false;

  pythonImportsCheck = [ "google.generativeai" ];

  meta = with lib; {
    description = "Python client library for Google's large language model PaLM API";
    homepage = "https://github.com/google/generative-ai-python";
    changelog = "https://github.com/google/generative-ai-python/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
