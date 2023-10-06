{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "razdel";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QzTA/f401OiIzw7YVJaMnfFPClR9+Qmnf0Y0+f/mJuY=";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "razdel" ];
  pythonImportCheck = [ "razdel" ];

  meta = with lib; {
    description = "Rule-based system for Russian sentence and word tokenization";
    homepage = "https://github.com/natasha/razdel";
    license = licenses.mit;
    maintainers = with maintainers; [ npatsakula ];
  };
}
