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
  version = "unstable-2021-03-25";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mvn23";
    repo = pname;
    rev = "1854ef4ffb907524ff457ba558e4979ba7fabd02";
    sha256 = "0zckd85dmzpz0drcgx16ly6kzh1f1slcxb9lrcf81wh1p4q9bcaa";
  };

  propagatedBuildInputs = [
    pyserial-asyncio
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [ "pyotgw" ];

  meta = with lib; {
    description = "Python module to interact the OpenTherm Gateway";
    homepage = "https://github.com/mvn23/pyotgw";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
