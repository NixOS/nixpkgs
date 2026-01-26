{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pick";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wong2";
    repo = "pick";
    tag = "v${version}";
    hash = "sha256-SnH37n0MCjO60IU6kUPxJkIC5vBCVGZXBhFfwvRI/tQ=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pick" ];

  meta = {
    description = "Module to create curses-based interactive selection list in the terminal";
    homepage = "https://github.com/wong2/pick";
    changelog = "https://github.com/wong2/pick/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
