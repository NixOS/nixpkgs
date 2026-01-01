{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  llm,
  openai,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  python-dotenv,
  pillow,
  llm-perplexity,
}:
buildPythonPackage rec {
  pname = "llm-perplexity";
<<<<<<< HEAD
  version = "2025.12.0";
=======
  version = "2025.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hex";
    repo = "llm-perplexity";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-jPSYwhEGph/1C9n/fv1nZurY4Inu/XNHYSE1r86N1Kw=";
=======
    hash = "sha256-8vgHlua+fPwZf2Accf0/CMFBIFAEZujP4hB3yTbLGG8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    llm
    openai
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
    python-dotenv
    pillow
  ];

  pythonImportsCheck = [ "llm_perplexity" ];

  passthru.tests = llm.mkPluginTest llm-perplexity;

  meta = {
    description = "LLM access to pplx-api";
    homepage = "https://github.com/hex/llm-perplexity";
    changelog = "https://github.com/hex/llm-perplexity/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jed-richards ];
  };
}
