{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, responses
}:

buildPythonPackage rec {
  pname = "python-twitch-client";
  version = "0.7.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tsifrer";
    repo = pname;
    rev = version;
    sha256 = "10wwkam3dw0nqr3v9xzigx1zjlrnrhzr7jvihddvzi84vjb6j443";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "twitch" ];

  meta = with lib; {
    description = "Python wrapper for the Twitch API";
    homepage = "https://github.com/tsifrer/python-twitch-client";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
