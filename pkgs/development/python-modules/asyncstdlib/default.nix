{ lib
, buildPythonPackage
, fetchFromGitHub
, typing-extensions
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncstdlib";
  version = "3.10.5";
  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "maxfischer2781";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ILb+iWg2xYWBEQY1a4jPITm4QCPO8qfVCPgO3YWIVAQ=";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "asyncstdlib"
  ];

  meta = with lib; {
    description = "Python library that extends the Python asyncio standard library";
    homepage = "https://asyncstdlib.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
