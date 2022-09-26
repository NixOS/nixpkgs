{ lib
, poetry-core
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, importlib-metadata
, packaging
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "dunamai";
  version = "1.13.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = "dunamai";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-UoqVfRdwOgxNLY17+dPgYO1GIPw3ZUwE/tiVzHjBxcY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    packaging
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # needs to be able to run dunami from PATH
  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  checkInputs = [
    pytestCheckHook
    setuptools
  ];

  pythonImportsCheck = [ "dunamai" ];

  meta = with lib; {
    description = "Dynamic version generation";
    homepage = "https://github.com/mtkennerly/dunamai";
    license = licenses.mit;
    maintainers = with maintainers; [ jmgilman ];
  };
}
