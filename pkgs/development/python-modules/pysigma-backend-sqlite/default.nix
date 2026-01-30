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
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-sqlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FmqsWwMn/xtKfPPUA025UcEmgsqiQ+8vQm13B/5oahQ=";
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
