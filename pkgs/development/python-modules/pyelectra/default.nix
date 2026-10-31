{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyelectra";
  version = "1.2.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jafar-atili";
    repo = "pyelectra";
    tag = finalAttrs.version;
    hash = "sha256-Z07v5sj+HkTNA7DIHRBeYjJgSUy2k3R+3bbBFW9RrOE=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "electrasmart" ];

  meta = {
    changelog = "https://github.com/jafar-atili/pyElectra/releases/tag/${finalAttrs.src.tag}";
    description = "Electra Smart Python Integration";
    homepage = "https://github.com/jafar-atili/pyelectra";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
