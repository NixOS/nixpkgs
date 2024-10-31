{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  alarmdecoder,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "adext";
  version = "0.4.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ajschmidt8";
    repo = "adext";
    rev = "refs/tags/v${version}";
    hash = "sha256-y8BvcSc3vD0FEWiyzW2Oh6PBS2Itjs2sz+9Dzh5yqSg=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ alarmdecoder ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "adext" ];

  meta = with lib; {
    description = "Python extension for AlarmDecoder";
    homepage = "https://github.com/ajschmidt8/adext";
    changelog = "https://github.com/ajschmidt8/adext/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
