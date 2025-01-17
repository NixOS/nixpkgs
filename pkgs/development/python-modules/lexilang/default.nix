{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  python,
}:

buildPythonPackage rec {
  pname = "lexilang";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LibreTranslate";
    repo = "LexiLang";
    tag = "v${version}";
    hash = "sha256-Yn6zthr6irkDsRx25NG9gOQc07xRpItwCc6+WqAhd/c=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} test.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Simple, fast dictionary-based language detector for short texts";
    homepage = "https://github.com/LibreTranslate/LexiLang";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ izorkin ];
  };
}
