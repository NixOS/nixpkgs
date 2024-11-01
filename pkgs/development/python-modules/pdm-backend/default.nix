{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # propagates
  importlib-metadata,

  # tests
  editables,
  git,
  mercurial,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pdm-backend";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "pdm-backend";
    rev = "refs/tags/${version}";
    hash = "sha256-YQavUP3RaZns9byli54feVtG92Stozr3T66WouQwF+s=";
  };

  env.PDM_BUILD_SCM_VERSION = version;

  dependencies = lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  pythonImportsCheck = [ "pdm.backend" ];

  nativeCheckInputs = [
    editables
    git
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

  meta = with lib; {
    homepage = "https://github.com/pdm-project/pdm-backend";
    changelog = "https://github.com/pdm-project/pdm-backend/releases/tag/${version}";
    description = "Yet another PEP 517 backend";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
