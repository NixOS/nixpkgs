{
  lib,
  fetchPypi,
  python3,
}:

let
  pname = "xenon";
  version = "0.9.3";
in
python3.pkgs.buildPythonApplication {

  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SnU42LoIql15BV+z4LI5PAvW19FqSrD83vAu8fEKQ/o=";
  };

  doCheck = false;

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    requests
    radon
    pyaml
  ];

  pythonImportsCheck = [ "xenon" ];

  meta = with lib; {
    description = "Monitoring tool based on radon";
    homepage = "https://github.com/rubik/xenon";
    license = licenses.mit;
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "xenon";
  };
}
