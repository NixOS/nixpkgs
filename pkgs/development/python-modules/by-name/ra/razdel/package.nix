{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "razdel";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QzTA/f401OiIzw7YVJaMnfFPClR9+Qmnf0Y0+f/mJuY=";
  };

  nativeCheckInputs = [ pytest7CheckHook ];
  enabledTestPaths = [ "razdel" ];
  pythonImportsCheck = [ "razdel" ];

  meta = with lib; {
    description = "Rule-based system for Russian sentence and word tokenization";
    mainProgram = "razdel-ctl";
    homepage = "https://github.com/natasha/razdel";
    license = licenses.mit;
    maintainers = with maintainers; [ npatsakula ];
  };
}
