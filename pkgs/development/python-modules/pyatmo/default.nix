{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, oauthlib
, requests
, requests_oauthlib
, freezegun
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, requests-mock
}:

buildPythonPackage rec {
  pname = "pyatmo";
  version = "5.2.3";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jabesq";
    repo = "pyatmo";
    rev = "v${version}";
    sha256 = "1w9rhh85z9m3c4rbz6zxlrxglsm5sk5d6796dsj1p1l3b3ad476z";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "oauthlib~=3.1" "oauthlib" \
      --replace "requests~=2.24" "requests"
  '';

  propagatedBuildInputs = [
    aiohttp
    oauthlib
    requests
    requests_oauthlib
  ];

  checkInputs = [
    freezegun
    pytest-asyncio
    pytest-mock
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
