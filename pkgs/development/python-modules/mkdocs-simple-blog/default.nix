{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mkdocs,
  poetry-core,
  pytestCheckHook,
  pyprojectVersionPatchHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "mkdocs-simple-blog";
  version = "0.4.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FernandoCelmer";
    repo = "mkdocs-simple-blog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z2+ou+bjE/glInl4of0gkoNEc9eGD8k/LDcQpKGWsB8=";
  };

  build-system = [ poetry-core ];

  dependencies = [ mkdocs ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "mkdocs_simple_blog" ];

  meta = {
    description = "Simple blog generator plugin for MkDocs";
    homepage = "https://fernandocelmer.github.io/mkdocs-simple-blog/";
    changelog = "https://github.com/FernandoCelmer/mkdocs-simple-blog/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
