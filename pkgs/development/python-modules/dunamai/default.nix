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
  version = "1.13.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = "dunamai";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-0x1bwu5X1P8f51NeupEQc0eghaqQIp3jb2uwZ0JDbgQ=";
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
