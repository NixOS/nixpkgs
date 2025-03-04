{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "legacy-cgi";
  version = "2.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jackrosenthal";
    repo = "legacy-cgi";
    tag = "v${version}";
    hash = "sha256-unVD8gUnF0sP360y/wWT2AkicEZ8nKy7tUK5tcCpQuc=";
  };

  build-system = [ poetry-core ];

  pythonImportsCheck = [
    "cgi"
    "cgitb"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Fork of the standard library cgi and cgitb modules, being deprecated in PEP-594";
    homepage = "https://github.com/jackrosenthal/legacy-cgi";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
