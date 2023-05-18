{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, unittestCheckHook
, pythonOlder
, yara-python
}:

buildPythonPackage rec {
  pname = "karton-yaramatcher";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ulWwPXbjqQXwSRi8MFdcx7vC7P19yu66Ll8jkuTesao=";
  };

  propagatedBuildInputs = [
    karton-core
    yara-python
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "karton.yaramatcher"
  ];

  meta = with lib; {
    description = "File and analysis artifacts yara matcher for the Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-yaramatcher";
    changelog = "https://github.com/CERT-Polska/karton-yaramatcher/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
