{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, packaging
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rmscene";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "ricklupton";
    repo = "rmscene";
    rev = "v${version}";
    hash = "sha256-uIvoKdW7caOfc8OEGIcyDwyos9NLwtZ++CeZdUO/G8M=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    packaging
  ];

  pythonImportsCheck = [ "rmscene" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/ricklupton/rmscene/blob/${src.rev}/README.md#changelog";
    description = "Read v6 .rm files from the reMarkable tablet";
    homepage = "https://github.com/ricklupton/rmscene";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
