{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, oauthlib
, requests
, requests_oauthlib
, freezegun
, pytestCheckHook
, requests-mock
}:

buildPythonPackage rec {
  pname = "pyatmo";
  version = "4.2.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jabesq";
    repo = "netatmo-api-python";
    rev = "v${version}";
    sha256 = "0b2k1814zg3994k60xdw5gpsl8k1wy9zndd0b1p4dfb5qkx9f8kp";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "oauthlib==3.1.0" "oauthlib"
  '';

  propagatedBuildInputs = [
    oauthlib
    requests
    requests_oauthlib
  ];

  checkInputs = [
    freezegun
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "pyatmo" ];

  meta = with lib; {
    description = "Simple API to access Netatmo weather station data";
    license = licenses.mit;
    homepage = "https://github.com/jabesq/netatmo-api-python";
    maintainers = with maintainers; [ delroth ];
  };
}
