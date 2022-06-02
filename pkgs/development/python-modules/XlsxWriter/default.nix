{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xlsxwriter";
  version = "3.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jmcnamara";
    repo = "XlsxWriter";
    rev = "RELEASE_${version}";
    hash = "sha256-9fIxNkOdM+Bz1F9AWq02H3LLQnefxGSAtp9kM2OtJ9M=";
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
