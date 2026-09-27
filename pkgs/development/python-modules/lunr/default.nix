{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  hatch-fancy-pypi-readme,
  nltk,
  nltk-data,
  pytestCheckHook,
  pytest-timeout,
}:
buildPythonPackage (finalAttrs: {
  pname = "lunr";
  version = "0.8.0";
  pyproject = true;
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "yeraydiazdiaz";
    repo = "lunr.py";
    tag = finalAttrs.version;
    hash = "sha256-47gLvelEiPuOC/OvQBy+Es1zCt+NfdC0AFTISviHn6k=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  optional-dependencies = {
    languages = [ nltk ];
  };

  preCheck = ''
    export NLTK_DATA=${nltk-data.stopwords}
  '';

  disabledTestMarks = [
    # Compare against lunr.js; require node and npm dependencies
    "acceptance"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
  ]
  ++ finalAttrs.passthru.optional-dependencies.languages;

  pythonImportsCheck = [ "lunr" ];
  meta = {
    description = "Python implementation of Lunr.js";
    homepage = "https://github.com/yeraydiazdiaz/lunr.py";
    changelog = "https://github.com/yeraydiazdiaz/lunr.py/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
