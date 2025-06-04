{
  lib,
  fetchFromGitHub,
  git,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "troubadix";
  version = "25.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "troubadix";
    tag = "v${version}";
    hash = "sha256-+2G7wlhtoKmjluHsmYb62i+DvWuXlaYw6ktYb77X/LA=";
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
    description = "Linting tool for NASL files";
    homepage = "https://github.com/greenbone/troubadix";
    changelog = "https://github.com/greenbone/troubadix/releases/tag/${src.tag}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "troubadix";
  };
}
