{ lib
, fetchFromGitHub
, buildPythonPackage
, text-unidecode
, chardet
, banal
, PyICU
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "normality";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "pudo";
    repo = "normality";
    rev = version;
    sha256 = "WvpMs02vBGnCSPkxo6r6g4Di2fKkUr2SsBflTBxlhkU=";
  };

  propagatedBuildInputs = [
    text-unidecode
    chardet
    banal
    PyICU
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "normality"
  ];

  meta = with lib; {
    description = "Micro-library to normalize text strings";
    homepage = "https://github.com/pudo/normality";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
  };
}
