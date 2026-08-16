{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "gamble";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "gamble";
    tag = version;
    hash = "sha256-vzaY5gJ0Ou2ArUJ0kuTWzTeLfiRDhUt/Hxpns9rFiDk=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gamble" ];

  meta = {
    description = "Collection of gambling classes/tools";
    homepage = "https://github.com/jpetrucciani/gamble";
    changelog = "https://github.com/jpetrucciani/gamble/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
}
