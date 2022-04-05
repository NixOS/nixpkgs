{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xlsxwriter";
  version = "3.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jmcnamara";
    repo = "XlsxWriter";
    rev = "RELEASE_${version}";
    hash = "sha256-I87/8OhMoI9/BRXdmTZ1Ul+d+/x+Kg/9CuqMgTsP8Eo=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xlsxwriter"
  ];

  meta = with lib; {
    description = "Module for creating Excel XLSX files";
    homepage = "https://xlsxwriter.readthedocs.io/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jluttine ];
  };
}
