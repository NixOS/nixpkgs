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
  version = "5.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-database";
    rev = "refs/tags/${version}";
    hash = "sha256-A7Xr24O8OvVAlURrR+SDCh8Uv9Yz3AUJSFDyDShVVjA=";
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
