{
  lib,
  anyascii,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  text-unidecode,
  unidecode,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-slugify";
  version = "9.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "un33k";
    repo = "python-slugify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WBhw5TnjxEks8tNLGTptL3ydwOzahRsdMFc54rnLGYA=";
  };

  build-system = [ setuptools ];

  dependencies = [ text-unidecode ];

  optional-dependencies = {
    anyascii = [ anyascii ];
    unidecode = [ unidecode ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "slugify" ];

  meta = {
    description = "Python Slugify application that handles Unicode";
    mainProgram = "slugify";
    homepage = "https://github.com/un33k/python-slugify";
    changelog = "https://github.com/un33k/python-slugify/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
