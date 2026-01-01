{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  gitUpdater,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "panzi-json-logic";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "panzi";
    repo = "panzi-json-logic";
    tag = "v${version}";
    hash = "sha256-P34+7SckMtiCTZbdKsjztNam+/HWtcVQEnGPMoPBw3g=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "json_logic" ];

<<<<<<< HEAD
  passthru.updateScript = gitUpdater { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Pure Python 3 JsonLogic and CertLogic implementation.";
    homepage = "https://github.com/panzi/panzi-json-logic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thanegill ];
  };
}
