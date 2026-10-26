{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  capstone,
  filebytes,
  keystone-engine,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ropper";
  version = "1.13.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sashs";
    repo = "Ropper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MOAbACLDdeKCMV4K/n1rAQlxDN0JoDIiUF6Zr3yPw8o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    capstone
    filebytes
  ];

  optional-dependencies = {
    ropchain = [ keystone-engine ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ropper" ];

  meta = {
    description = "Show information about files in different file formats";
    homepage = "https://scoding.de/ropper/";
    changelog = "https://github.com/sashs/Ropper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bennofs ];
    mainProgram = "ropper";
  };
})
