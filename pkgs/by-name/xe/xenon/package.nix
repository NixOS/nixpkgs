{
  lib,
  fetchPypi,
  python3,
}:

let
  pname = "xenon";
  version = "0.9.1";
in
python3.pkgs.buildPythonApplication {

  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1nRREcPiWLdJpP1CSxuJnZnqGDzqIyNl7i+I/n2AwDs=";
  };

  doCheck = false;

  propagatedBuildInputs = with python3.pkgs; [
    requests
    radon
    pyaml
  ];

  meta = with lib; {
    description = "Monitoring tool based on radon";
    homepage = "https://github.com/rubik/xenon";
    license = licenses.mit;
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "xenon";
  };
}
