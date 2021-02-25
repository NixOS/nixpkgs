{ lib
, asyncio-dgram
, buildPythonPackage
, click
, dnspython
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "mcstatus";
  version = "5.1.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Dinnerbone";
    repo = pname;
    rev = "release-${version}";
    sha256 = "1a3qrl6w76ayqkl1knaz5ai0brrzpjfdk33lyb1n1p7gnc73nhlr";
  };

  propagatedBuildInputs = [
    asyncio-dgram
    click
    dnspython
    six
  ];

  checkInputs = [
    mock
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
