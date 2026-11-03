{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # tests
  editables,
  gitMinimal,
  mercurial,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pdm-backend";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "pdm-backend";
    tag = version;
    hash = "sha256-SQQU7hY1WQhMRa72NL5zCtXam1UlwR4RhP6Hng2adZI=";
  };

  env.PDM_BUILD_SCM_VERSION = version;

  pythonImportsCheck = [ "pdm.backend" ];

  nativeCheckInputs = [
    editables
    gitMinimal
    mercurial
    pytestCheckHook
    setuptools
  ];

  preCheck = ''
    unset PDM_BUILD_SCM_VERSION

    # tests require a configured git identity
    export HOME=$TMPDIR
    git config --global user.name nixbld
    git config --global user.email nixbld@localhost
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://github.com/pdm-project/pdm-backend";
    changelog = "https://github.com/pdm-project/pdm-backend/releases/tag/${version}";
    description = "Yet another PEP 517 backend";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
