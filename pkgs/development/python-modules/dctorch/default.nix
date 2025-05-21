{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  numpy,
  scipy,
  torch,
}:

buildPythonPackage rec {
  pname = "dctorch";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TmfLAkiofrQNWYBhIlY4zafbZPgFftISCGloO/rlEG4=";
  };

  pythonRelaxDeps = [ "numpy" ];

  build-system = [ poetry-core ];

  dependencies = [
    numpy
    scipy
    torch
  ];

  pythonImportsCheck = [ "dctorch" ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Fast discrete cosine transforms for pytorch";
    homepage = "https://pypi.org/project/dctorch/";
    license = licenses.mit;
    teams = [ teams.tts ];
  };
}
