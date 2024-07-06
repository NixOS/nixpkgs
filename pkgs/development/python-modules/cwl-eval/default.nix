{ lib
, fetchPypi
, buildPythonPackage
, numpy
}:

buildPythonPackage rec {
  pname = "cwl-eval";
  version = "1.0.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/55KEkHu2CBn6+dgXnz0TZI9fZ12TyIgNPyCFtDvMn0=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  meta = with lib; {
    homepage = "https://github.com/ireval/cwl";
    mainProgram = "cwl-eval";
    license = licenses.mit;
    description = "C/W/L Evaluation Script";
    maintainers = [ maintainers.gm6k ];
  };
}
