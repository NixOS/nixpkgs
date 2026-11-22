{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysigma-backend-sqlite";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-sqlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oeZd1nla+wFz/GcXbCIxbHON0npYsPKyxjHXs0ztaP4=";
  };

  pythonRelaxDeps = [ "pysigma" ];

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "sigma.backends.sqlite" ];

  meta = {
    description = "Library to support sqlite for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-sqlite";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-sqlite/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
