{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "aiotractive";
  version = "0.5.3";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rkylzbxxy3p744q1iqcvpnkn12ra6ja16vhqzidn702n4h5377j";
  };

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiotractive" ];

  meta = with lib; {
    description = "Python client for the Tractive REST API";
    homepage = "https://github.com/zhulik/aiotractive";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
