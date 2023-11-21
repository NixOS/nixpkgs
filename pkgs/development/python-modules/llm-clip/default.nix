{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  llm,
  pytestCheckHook,
  pythonOlder,
  sentence-transformers,
  setuptools,
}:
buildPythonPackage rec {
  pname = "llm-clip";
  version = "0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-QeX8YBees4W8RdBuYrRX2iv93otXIsUEmfMd914wVfo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    llm
  ];

  propagatedBuildInputs = [
    sentence-transformers
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Tests will try to download files from huggingface
  doCheck = false;

  # Avoid warnings with not having a writable folder when testing imports
  preBuild = ''
    export TRANSFORMERS_CACHE=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "llm_clip"
  ];

  meta = with lib; {
    homepage = "https://github.com/simonw/llm-clip";
    description = "Generate embeddings for images and text using CLIP with LLM";
    changelog = "https://github.com/simonw/llm-clip/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
  };
}
