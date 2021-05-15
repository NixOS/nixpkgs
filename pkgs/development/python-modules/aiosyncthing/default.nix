{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, expects
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, yarl
}:

buildPythonPackage rec {
  pname = "aiosyncthing";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = pname;
    rev = "v${version}";
    sha256 = "0704qbg3jy80vaw3bcvhy988s1qs3fahpfwkja71fy70bh0vc860";
  };

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  checkInputs = [
    aioresponses
    expects
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ];

  pythonImportsCheck = [ "aiosyncthing" ];

  meta = with lib; {
    description = "Python client for the Syncthing REST API";
    homepage = "https://github.com/zhulik/aiosyncthing";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
