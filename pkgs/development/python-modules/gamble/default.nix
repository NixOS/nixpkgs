{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "gamble";
  version = "0.14.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "gamble";
    rev = "refs/tags/${version}";
    hash = "sha256-vzaY5gJ0Ou2ArUJ0kuTWzTeLfiRDhUt/Hxpns9rFiDk=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gamble" ];

  meta = with lib; {
    description = "Collection of gambling classes/tools";
    homepage = "https://github.com/jpetrucciani/gamble";
    changelog = "https://github.com/jpetrucciani/gamble/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
