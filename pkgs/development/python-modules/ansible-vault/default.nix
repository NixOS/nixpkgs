{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  ansible-core,
  pyyaml,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ansible-vault";
  version = "4.1.0";
  pyproject = true;

  # Fetched from GitHub because PyPI doesn't ship the test suite.
  src = fetchFromGitHub {
    owner = "tomoh1r";
    repo = "ansible-vault";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JSFZavafUByn4u+WkPo01lPCzjv/ekCM8nvWSy4QrAs=";
  };

  # The test helper resolves the ansible-vault CLI as a sibling of sys.executable,
  # which holds in a venv but not under nix's split store; point it at ansible-core.
  postPatch = ''
    substituteInPlace test/lib/testing/__init__.py \
      --replace-fail 'os.path.join(os.path.dirname(sys.executable), "ansible-vault")' \
                     '"${lib.getExe' ansible-core "ansible-vault"}"'
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    ansible-core
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # importing ansible writes to HOME, without this import check and checkPhase would both fail
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # dev-only lint suite (black/flake8/isort/pylint), not useful for nixpkgs
    "test/linter"
  ];

  disabledTests = [
    # This fails on a benign reformatting of ansible-core's error message
    "TestCannotLoadWithInvalidPassword"
  ];

  pythonImportsCheck = [ "ansible_vault" ];

  meta = {
    description = "R/W an ansible-vault yaml file";
    homepage = "https://github.com/tomoh1r/ansible-vault";
    changelog = "https://github.com/tomoh1r/ansible-vault/blob/master/CHANGES.txt";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ StillerHarpo ];
  };
})
