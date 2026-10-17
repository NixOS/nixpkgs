{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  tqdm,
  spacy,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysbd";
  version = "0.3.4";
  pyproject = true;

  __structuredAttrs = true;

  # provides no sdist on pypi
  src = fetchFromGitHub {
    owner = "nipunsadvilkar";
    repo = "pySBD";
    tag = "v${finalAttrs.version}";
    hash = "sha256-txUlRMB4V7Di4ISlKuKE1bvHfEZ2gPwJh6b8M0TF54o=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    spacy
    tqdm
  ];

  pythonImportsCheck = [ "pysbd" ];

  meta = {
    description = "Pysbd (Python Sentence Boundary Disambiguation) is a rule-based sentence boundary detection that works out-of-the-box across many languages";
    homepage = "https://github.com/nipunsadvilkar/pySBD";
    changelog = "https://github.com/nipunsadvilkar/pySBD/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.tts ];
  };
})
