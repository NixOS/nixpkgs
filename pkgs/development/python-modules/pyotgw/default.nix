{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyotgw";
  version = "2.0.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mvn23";
    repo = pname;
    rev = version;
    hash = "sha256-82pGKcF7L7WBxInU7lkYTKQLkse5/HY8x0ZHZIyqCW4=";
  };

  propagatedBuildInputs = [
    pyserial-asyncio
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
  ];

  pythonImportsCheck = [ "pyotgw" ];

  meta = with lib; {
    description = "Python module to interact the OpenTherm Gateway";
    homepage = "https://github.com/mvn23/pyotgw";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
