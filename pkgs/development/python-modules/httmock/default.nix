{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "httmock";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "patrys";
    repo = "httmock";
    rev = version;
    sha256 = "sha256-yid4vh1do0zqVzd1VV7gc+Du4VPrkeGFsDHqNbHL28I=";
  };

  nativeCheckInputs = [
    requests
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "httmock" ];

  meta = with lib; {
    description = "A mocking library for requests";
    homepage = "https://github.com/patrys/httmock";
    license = licenses.asl20;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
