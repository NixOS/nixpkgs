{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  text-unidecode,
  unidecode,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-slugify";
  version = "9.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "un33k";
    repo = "python-slugify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bCOsExVFv+R4T6HQcJK3biyIHOXf5Ax8ZA9jQfno8v4=";
  };

  build-system = [ setuptools ];

  dependencies = [ text-unidecode ];

  optional-dependencies = {
    unidecode = [ unidecode ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "slugify" ];

  meta = {
    description = "Python Slugify application that handles Unicode";
    homepage = "https://github.com/un33k/python-slugify";
    changelog = "https://github.com/un33k/python-slugify/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "slugify";
  };
})
