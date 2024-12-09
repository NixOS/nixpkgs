{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools-scm,
  toml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pure_eval";
  version = "0.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9N+UcgAv30s4ctgsBrOHiix4BoXhKPgxH/GOz/NIFdU=";
  };

  buildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ toml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pure_eval" ];

  meta = with lib; {
    description = "Safely evaluate AST nodes without side effects";
    homepage = "https://github.com/alexmojaki/pure_eval";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
