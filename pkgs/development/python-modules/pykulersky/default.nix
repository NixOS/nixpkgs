{ lib
, bleak
, buildPythonPackage
, click
, fetchFromGitHub
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pykulersky";
  version = "0.5.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = pname;
    rev = version;
    sha256 = "1fzfixnl28rny7c3wr6gcdpqhyrz7z2aqq6qfwkxnkq2kqdbpmmg";
  };

  propagatedBuildInputs = [
    bleak
    click
  ];

  checkInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pykulersky" ];

  meta = with lib; {
    description = "Python module to control Brightech Kuler Sky Bluetooth LED devices";
    homepage = "https://github.com/emlove/pykulersky";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
