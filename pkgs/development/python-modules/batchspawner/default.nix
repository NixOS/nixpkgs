{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  jinja2,
  jupyterhub,
  pythonOlder,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "batchspawner";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "batchspawner";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z7kB8b7s11wokTachLI/N+bdUV+FfCRTemL1KYQpzio=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    jinja2
    jupyterhub
  ];

  preCheck = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=batchspawner" ""
  '';

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "batchspawner" ];

  meta = with lib; {
    description = "A spawner for Jupyterhub to spawn notebooks using batch resource managers";
    mainProgram = "batchspawner-singleuser";
    homepage = "https://github.com/jupyterhub/batchspawner";
    changelog = "https://github.com/jupyterhub/batchspawner/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
