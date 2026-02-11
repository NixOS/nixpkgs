{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python,
}:

buildPythonPackage rec {
  pname = "lexilang";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LibreTranslate";
    repo = "LexiLang";
    tag = "v${version}";
    hash = "sha256-5/P9u2naTTyG5l3uhrinRIAekyOYn8OKLwb/VEON2Vc=";
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
