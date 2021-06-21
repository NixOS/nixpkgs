{ lib
, asyncio-dgram
, buildPythonPackage
, click
, dnspython
, fetchFromGitHub
, mock
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "mcstatus";
  version = "6.1.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Dinnerbone";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ncw8ILOD+i5aW78opv62VRcV58MQb5IG33MGTqNgDRk=";
  };

  propagatedBuildInputs = [
    asyncio-dgram
    click
    dnspython
    six
  ];

  checkInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mcstatus" ];

  meta = with lib; {
    description = "Python library for checking the status of Minecraft servers";
    homepage = "https://github.com/Dinnerbone/mcstatus";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
