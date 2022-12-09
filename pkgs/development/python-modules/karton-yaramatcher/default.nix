{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, unittestCheckHook
, yara-python
}:

buildPythonPackage rec {
  pname = "karton-yaramatcher";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ulWwPXbjqQXwSRi8MFdcx7vC7P19yu66Ll8jkuTesao=";
  };

  propagatedBuildInputs = [
    karton-core
    yara-python
  ];

  checkInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "karton.yaramatcher" ];

  meta = with lib; {
    description = "File and analysis artifacts yara matcher for the Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-yaramatcher";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
