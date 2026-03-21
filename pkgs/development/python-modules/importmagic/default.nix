{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "importmagic";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = "importmagic";
    tag = finalAttrs.version;
    hash = "sha256-776HbSRl5hIrSyIyIF7jnNAJF41QzdjXe0vDaKwlCnc=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "importmagic" ];

  meta = {
    description = "Python Import Magic - automagically add, remove and manage imports";
    homepage = "https://github.com/alecthomas/importmagic";
    changelog = "https://github.com/alecthomas/importmagic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ onny ];
  };
})
