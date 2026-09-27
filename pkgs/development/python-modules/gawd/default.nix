{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ruamel-yaml,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "gawd";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sgl-umons";
    repo = "gawd";
    tag = finalAttrs.version;
    hash = "sha256-DCcU7vO5VApRsO+ljVs827TrHIfe3R+1/2wgBEcp1+c=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [ ruamel-yaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gawd" ];

  meta = {
    changelog = "https://github.com/sgl-umons/gawd/releases/tag/${finalAttrs.version}";
    description = "Python library and command-line tool for computing syntactic differences between two GitHub Actions workflow files";
    mainProgram = "gawd";
    homepage = "https://github.com/sgl-umons/gawd";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
