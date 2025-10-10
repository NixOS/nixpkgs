{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jinja2,
  jupyterhub,

  # tests
  pytest-asyncio_0,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "batchspawner";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "batchspawner";
    tag = "v${version}";
    hash = "sha256-Z7kB8b7s11wokTachLI/N+bdUV+FfCRTemL1KYQpzio=";
  };

  # When using pytest-asyncio>=0.24, jupyterhub no longer re-defines the event_loop function in its
  # conftest.py, so it cannot be imported from there.
  postPatch = ''
    substituteInPlace batchspawner/tests/conftest.py \
      --replace-fail \
        "from jupyterhub.tests.conftest import db, event_loop  # noqa" \
        "from jupyterhub.tests.conftest import db"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    jinja2
    jupyterhub
  ];

  nativeCheckInputs = [
    pytest-asyncio_0
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "batchspawner" ];

  meta = {
    description = "Spawner for Jupyterhub to spawn notebooks using batch resource managers";
    mainProgram = "batchspawner-singleuser";
    homepage = "https://github.com/jupyterhub/batchspawner";
    changelog = "https://github.com/jupyterhub/batchspawner/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
