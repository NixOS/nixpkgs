{ lib
, buildPythonPackage
, fetchFromGitHub
, google-ai-generativelanguage
, google-api-core
, google-auth
, protobuf
, pythonOlder
, pythonRelaxDepsHook
, tqdm
}:

buildPythonPackage rec {
  pname = "google-generativeai";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "google";
    repo = "generative-ai-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-zlLfA8wlXCsBXvzTHNW8y30/DvWMgf7DnpShsvjZXZ4=";
  };

  pythonRelaxDeps = [
    "google-ai-generativelanguage"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    google-ai-generativelanguage
    google-auth
    google-api-core
    protobuf
    tqdm
  ];

  # Issue with the google.ai module. Check with the next release
  doCheck = false;

  pythonImportsCheck = [
    "google.generativeai"
  ];

  meta = with lib; {
    description = "Python client library for Google's large language model PaLM API";
    homepage = "https://github.com/google/generative-ai-python";
    changelog = "https://github.com/google/generative-ai-python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
