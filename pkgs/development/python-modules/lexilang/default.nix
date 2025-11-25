{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python,
}:

buildPythonPackage rec {
  pname = "lexilang";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LibreTranslate";
    repo = "LexiLang";
    tag = "v${version}";
    hash = "sha256-+AtdmkYKJgQwFOK0B2jkrNfSWGaydv6tCVjNnb2DJng=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "lexilang" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} test.py
    runHook postCheck
  '';

  meta = {
    description = "Simple, fast dictionary-based language detector for short texts";
    homepage = "https://github.com/LibreTranslate/LexiLang";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ izorkin ];
  };
}
