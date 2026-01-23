{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  pandas,
  pyannote-core,
  pyyaml,
  typer,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyannote-database";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-database";
    tag = version;
    hash = "sha256-WDAkxoSI/IW2nIXCDoKa+p2ep1xcWW6WGNHCCZT51tY=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    pandas
    pyannote-core
    pyyaml
    # Imported in pyannote/database/cli.py
    typer
  ];

  pythonImportsCheck = [ "pyannote.database" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    $out/bin/pyannote-database --help
  '';

  meta = {
    description = "Reproducible experimental protocols for multimedia (audio, video, text) database";
    homepage = "https://github.com/pyannote/pyannote-database";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "pyannote-database";
  };
}
