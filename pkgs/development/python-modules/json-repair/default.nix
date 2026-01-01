{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "json-repair";
<<<<<<< HEAD
  version = "0.54.3";
=======
  version = "0.54.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mangiucugna";
    repo = "json_repair";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-mLysH1+kr2PcmRphfcYeZ9K1hSinQXFDCrjTxc/MB0s=";
=======
    hash = "sha256-OwzyDrdN6jRxA/KthmrGgtfE1ZN89XebxWgtovoK2Nk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Disable benchmark tests
    "tests/test_performance.py"
  ];

  pythonImportsCheck = [ "json_repair" ];

  meta = {
    description = "Module to repair invalid JSON, commonly used to parse the output of LLMs";
    homepage = "https://github.com/mangiucugna/json_repair/";
    changelog = "https://github.com/mangiucugna/json_repair/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ greg ];
    mainProgram = "json_repair";
  };
}
