{ lib
, asynctest
, buildPythonPackage
, click
, fetchFromGitHub
, justbackoff
, pythonOlder
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "nessclient";
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nickw444";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-zjUYdSHIMCB4cCAsOOQZ9YgmFTskzlTUs5z/xPFt01Q=";
  };

  propagatedBuildInputs = [
    justbackoff
    click
  ];

  checkInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nessclient"
  ];

  meta = with lib; {
    description = "Python implementation/abstraction of the Ness D8x/D16x Serial Interface ASCII protocol";
    homepage = "https://github.com/nickw444/nessclient";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
