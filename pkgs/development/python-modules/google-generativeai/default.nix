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
, typing-extensions
}:

buildPythonPackage rec {
  pname = "google-generativeai";
  version = "0.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "google";
    repo = "generative-ai-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-SL0jnuDHjeiqDq1VvWr4vQPFZ5yyea/OAGArmxztwB4=";
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
    typing-extensions
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
