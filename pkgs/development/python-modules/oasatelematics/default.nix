{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "oasatelematics";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "panosmz";
    repo = "oasatelematics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pqjzvLeVGW5rC3lK/9WnYdCLyF1fM7GGwzEG5h2lKPA=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oasatelematics" ];

  meta = {
    description = "Python wrapper for the OASA Telematics API";
    homepage = "https://github.com/panosmz/oasatelematics";
    changelog = "https://github.com/panosmz/oasatelematics/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
