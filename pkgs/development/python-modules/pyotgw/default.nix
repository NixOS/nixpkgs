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
  version = "2.0.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mvn23";
    repo = pname;
    rev = version;
    hash = "sha256-lmhFQ1HhRuiS++NsELA53YafrJ9uX2UDBQ9Kgyq0N0o=";
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
