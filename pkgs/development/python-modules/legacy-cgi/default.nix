{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "legacy-cgi";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jackrosenthal";
    repo = "legacy-cgi";
    rev = "refs/tags/v${version}";
    hash = "sha256-hhWZoRswkuwvgkcKthNhMkPPhhoRH4TjdNp+orluQTQ=";
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
