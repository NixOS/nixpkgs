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
  version = "0.4.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ajschmidt8";
    repo = "adext";
    tag = "v${version}";
    hash = "sha256-KzL9yNdWgeO4Q5NzyHgxWv5gy2Awr86qYD526dyZCtM=";
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
