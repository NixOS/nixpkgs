{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
}:

buildPythonPackage rec {
  pname = "plotext";
  version = "6.0.0b0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "piccolomo";
    repo = "plotext";
    tag = version;
    hash = "sha256-81+AR/FOftlzR0XROOyeTMH9F1mgwSVkCIsRec/4i40=";
  };

  # Package does not have a conventional test suite that can be run with either
  # `pytestCheckHook` or the standard setuptools testing situation.
  doCheck = false;

  pythonImportsCheck = [ "plotext" ];

  meta = {
    description = "Plotting directly in the terminal";
    mainProgram = "plotext";
    homepage = "https://github.com/piccolomo/plotext";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
