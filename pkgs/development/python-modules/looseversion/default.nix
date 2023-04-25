{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "looseversion";
  version = "1.0.3";
  format = "flit";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-A1KIhg4a/mfWPqnHAN2dCVxyTi5XIqOQKd2RZS1DFu0";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];
  pytestFlagsArray = [ "tests.py" ];
  pythonImportsCheck = [ "looseversion" ];

  meta = with lib; {
    description = "Version numbering for anarchists and software realists";
    homepage = "https://github.com/effigies/looseversion";
    license = licenses.psfl;
    maintainers = with maintainers; [ pelme ];
  };
}
