{ lib
, poetry-core
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, importlib-metadata
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dunamai";
  version = "1.11.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = "dunamai";
    rev = "v${version}";
    sha256 = "sha256-nkE9QBziCQA/aN+Z0OuqJlf5FJ4fidE7u5Gt25zjX0c=";
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
  ];

  pythonImportsCheck = [ "dunamai" ];

  meta = with lib; {
    description = "Dynamic version generation";
    homepage = "https://github.com/mtkennerly/dunamai";
    license = licenses.mit;
    maintainers = with maintainers; [ jmgilman ];
  };
}
