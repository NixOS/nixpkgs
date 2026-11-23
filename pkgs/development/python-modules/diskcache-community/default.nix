{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pytest-cov-stub,
  pytest-django,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "diskcache-community";
  version = "5.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "secondwindoss";
    repo = "diskcache-community";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MTSCyGPmt4UFuvgdz01ECLcwtuUwv8yXiA4o4piaLGc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-django
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "diskcache_community" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Disk and file backed persistent cache";
    homepage = "https://github.com/secondwindoss/diskcache-community";
    changelog = "https://github.com/secondwindoss/diskcache-community/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
