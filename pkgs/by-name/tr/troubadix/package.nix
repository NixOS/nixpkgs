{
  lib,
  fetchFromGitHub,
  git,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "troubadix";
  version = "26.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "troubadix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FWauAvySks536KFdU/4X6ru2zr2nwIWzlfOG9OpZ9m4=";
  };

  pythonRelaxDeps = [
    "pontos"
    "validators"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    chardet
    charset-normalizer
    pkgs.codespell
    gitpython
    networkx
    pontos
    python-magic
    validators
  ];

  nativeCheckInputs = with python3.pkgs; [
    git
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "troubadix" ];

  disabledTests = [
    # AssertionError
    "test_ok"
    # TypeError
    "testgit"
  ];

  meta = {
    description = "Linting tool for NASL files";
    homepage = "https://github.com/greenbone/troubadix";
    changelog = "https://github.com/greenbone/troubadix/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "troubadix";
  };
})
