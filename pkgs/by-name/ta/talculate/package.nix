{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
}:

let
  textual = python3.pkgs.textual.overridePythonAttrs (old: {
    version = "3.7.0";
    src = fetchPypi {
      pname = "textual";
      version = "3.7.0";
      sha256 = "sha256-1ctxC0aRotm5B1/y3J6+zy2DaciTrzNU2tNElgyR18k=";
    };
    # https://github.com/NixOS/nixpkgs/pull/425777
    doCheck = false; # tests fail
  });

  tree-sitter = python3.pkgs.tree-sitter.overridePythonAttrs (old: {
    version = "0.21.0";
    src = fetchPypi {
      pname = "tree-sitter";
      version = "0.21.0";
      sha256 = "sha256-x07J7/MODFufAO5XjMpk3zIrmIXIoVNkosU39IWrzHc=";
    };
    doCheck = false; # tests fail
  });
in

python3.pkgs.buildPythonApplication rec {
  pname = "talculate";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nooneknowspeter";
    repo = "talculate";
    rev = version;
    hash = "sha256-f5WCOKfZHkCvCwRoq2GKOjklCTJKKcyPyqXDt2jDlKg=";
  };

  build-system = [
    python3.pkgs.poetry-core
  ];

  dependencies = with python3.pkgs; [
    pyperclip
    pyyaml
    rich
    textual
    tree-sitter
    xdg
  ];

  pythonImportsCheck = [
    "talculate"
  ];

  meta = {
    description = "A programmer oriented tui calculator. simple keys. minimal ui";
    homepage = "https://github.com/nooneknowspeter/talculate";
    changelog = "https://github.com/nooneknowspeter/talculate/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ nooneknowspeter ];
    mainProgram = "talc";
  };
}
