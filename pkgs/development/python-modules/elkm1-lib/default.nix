{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pyserial-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "elkm1-lib";
  version = "1.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "gwww";
    repo = "elkm1";
    rev = version;
    hash = "sha256-JZohQ0xLFfLVMGlw89uC9OQF6SMddcCOsotshavynCk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pyserial-asyncio
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "elkm1_lib"
  ];

  meta = with lib; {
    description = "Python module for interacting with ElkM1 alarm/automation panel";
    homepage = "https://github.com/gwww/elkm1";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
