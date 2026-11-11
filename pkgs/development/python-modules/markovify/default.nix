{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  unidecode,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "markovify";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "jsvine";
    repo = "markovify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FXsEdazx72K/ZC/14bN0SgeL+eTvuEZKfPe9lBOFSuI=";
  };

  # specific to buildPythonPackage, see its reference
  pyproject = true;
  build-system = [
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "markovify" ];

  dependencies = [
    unidecode
  ];

  meta = {
    description = "Extensible Markov chain generator";
    homepage = "https://github.com/jsvine/markovify";
    changelog = "https://github.com/jsvine/markovify/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      MCT32
    ];
  };
})
