{ lib
, buildPythonPackage
, fetchFromGitHub
, google-ai-generativelanguage
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "google-generativeai";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "google";
    repo = "generative-ai-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-caFq7BZKRuNU7fKJWeWSbbDFNpav7OrIET4OQSHkPz4=";
  };

  pythonRelaxDeps = [
    "google-ai-generativelanguage"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    google-ai-generativelanguage
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
