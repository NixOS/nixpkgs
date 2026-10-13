{
  lib,
  buildPythonPackage,
  construct,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  python-dateutil,
  rich,
}:

buildPythonPackage (finalAttrs: {
  pname = "procmon-parser";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eronnen";
    repo = "procmon-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hM+/sdW/H8QVt5kckAP1M96nn6mJmV8oWVl9RsjDf88=";
  };

  build-system = [ hatchling ];

  dependencies = [ construct ];

  nativeCheckInputs = [
    pytestCheckHook
    python-dateutil
    rich
  ];

  pythonImportsCheck = [ "procmon_parser" ];

  meta = {
    description = "Parser to process monitor file formats";
    homepage = "https://github.com/eronnen/procmon-parser/";
    changelog = "https://github.com/eronnen/procmon-parser/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
