{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "asciitree";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mbr";
    repo = "asciitree";
    tag = finalAttrs.version;
    hash = "sha256-67GWk6K2AyEyt5lzL0LMRnY+Uxtsig6ld2rNTvZe5ro=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asciitree" ];

  meta = {
    description = "Draws ASCII trees";
    homepage = "https://github.com/mbr/asciitree";
    changelog = "https://github.com/mbr/asciitree/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
