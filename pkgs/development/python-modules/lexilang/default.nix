{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "lexilang";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "LibreTranslate";
    repo = "LexiLang";
    rev = "refs/tags/v${version}";
    hash = "sha256-TLkaqCE9NDjN2XuYOUkeeWIRcqkxrdg31fS4mEnlcEo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} test.py
    runHook postCheck
  '';

  pythonImportsCheck = [
    "lexilang"
  ];

  meta = with lib; {
    description = "Dictionary-based language detector for short texts";
    homepage = "https://github.com/LibreTranslate/LexiLang";
    changelog = "https://github.com/LibreTranslate/LexiLang/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab izorkin ];
  };
}
