{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pandas,
  pyannote-core,
  pythonOlder,
  pyyaml,
  setuptools,
  typer,
  versioneer,
}:

buildPythonPackage rec {
  pname = "pyannote-database";
  version = "5.1.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-database";
    tag = version;
    hash = "sha256-MQSSS3h4Jyxs3kwvSYNjBWbY6l/SIIUCTxXInLFE8F8=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    pyannote-core
    pyyaml
    pandas
    typer
  ];

  pythonImportsCheck = [ "pyannote.database" ];

  meta = with lib; {
    description = "Reproducible experimental protocols for multimedia (audio, video, text) database";
    homepage = "https://github.com/pyannote/pyannote-database";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "pyannote-database";
  };
}
