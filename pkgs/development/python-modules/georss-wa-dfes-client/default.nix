{ lib
, buildPythonPackage
, fetchFromGitHub
, georss-client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "georss-wa-dfes-client";
  version = "0.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-wa-dfes-client";
    rev = "v${version}";
    sha256 = "0zfjq6yyrss61vwgdrykwkikb009q63kg9ab6ryb2509wiwwfwvk";
  };

  propagatedBuildInputs = [
    georss-client
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "georss_wa_dfes_client" ];

  meta = with lib; {
    description = "Python library for accessing WA Department of Fire and Emergency Services (DFES) feed";
    homepage = "https://github.com/exxamalte/python-georss-wa-dfes-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
