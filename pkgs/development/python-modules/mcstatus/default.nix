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
  version = "5.1.4";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Dinnerbone";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k8hjv965svbm95m7jaawlhdbxqpkjchlwvjwn1n7z90dfgn5kih";
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

  postPatch = ''
    substituteInPlace requirements.txt --replace "dnspython3" "dnspython"
  '';

  pythonImportsCheck = [ "mcstatus" ];

  meta = with lib; {
    description = "Python library for checking the status of Minecraft servers";
    homepage = "https://github.com/Dinnerbone/mcstatus";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
