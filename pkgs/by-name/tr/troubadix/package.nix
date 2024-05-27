{
  lib,
  fetchFromGitHub,
  git,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "troubadix";
  version = "24.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "troubadix";
    rev = "refs/tags/v${version}";
    hash = "sha256-kA+9zcP3unNb2tE3OU8J/3xHX+pRZ/06lEQtH/0QEk4=";
  };

  pythonRelaxDeps = [ "validators" ];

  build-system = with python3.pkgs; [ poetry-core ];

  nativeBuildInputs = with python3.pkgs; [ pythonRelaxDepsHook ];

  dependencies = with python3.pkgs; [
    chardet
    charset-normalizer
    pkgs.codespell
    gitpython
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

  meta = with lib; {
    description = "A linting tool for NASL files";
    homepage = "https://github.com/greenbone/troubadix";
    changelog = "https://github.com/greenbone/troubadix/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "troubadix";
  };
}
