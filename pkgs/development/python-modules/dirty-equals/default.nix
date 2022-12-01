{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, pytz
, typing-extensions
}:

buildPythonPackage rec {
  pname = "dirty-equals";
  version = "0.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rh7N/VRx4sv/MhhGPkaYCn2d19Sv5er2CkG6/fJuXX4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pytz
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dirty_equals"
  ];

  meta = with lib; {
    description = "Module for doing dirty (but extremely useful) things with equals";
    homepage = "https://github.com/samuelcolvin/dirty-equals";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
