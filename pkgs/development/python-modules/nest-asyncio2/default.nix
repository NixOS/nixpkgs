{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "nest-asyncio2";
  version = "1.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Chaoses-Ib";
    repo = "nest-asyncio2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qNetaOdR4icUXWncat4vITwnjmx5MhAgUz0t61Bvztc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nest_asyncio2" ];

  meta = {
    description = "Patch asyncio to allow nested event loops";
    homepage = "https://github.com/Chaoses-Ib/nest-asyncio2";
    changelog = "https://github.com/Chaoses-Ib/nest-asyncio2/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    teams = [ lib.teams.jupyter ];
  };
})
