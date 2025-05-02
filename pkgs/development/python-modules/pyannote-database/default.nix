{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, pyannote-core
, pyyaml
, pandas
, typer
}:

buildPythonPackage rec {
  pname = "pyannote-database";
  version = "5.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-database";
    rev = version;
    hash = "sha256-A7Xr24O8OvVAlURrR+SDCh8Uv9Yz3AUJSFDyDShVVjA=";
  };

  propagatedBuildInputs = [
    pyannote-core
    pyyaml
    pandas
    typer
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "pyannote.database" ];

  meta = with lib; {
    description = "Reproducible experimental protocols for multimedia (audio, video, text) database";
    mainProgram = "pyannote-database";
    homepage = "https://github.com/pyannote/pyannote-database";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
