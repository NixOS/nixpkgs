{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "asyncio-throttle";
  version = "1.0.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hallazzang";
    repo = pname;
    rev = "v${version}";
    sha256 = "0raqnrnp42cn1c7whbm7ajbgaczx33k6hbxsj30nh998pqxhh4sj";
  };

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asyncio_throttle" ];

  meta = with lib; {
    description = "Simple, easy-to-use throttler for asyncio";
    homepage = "https://github.com/hallazzang/asyncio-throttle";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
