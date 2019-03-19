{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, requests_oauthlib
, isodate
, certifi
, aiohttp
, aiodns
, pytest
, httpretty
}:

buildPythonPackage rec {
  version = "0.6.4";
  pname = "msrest";

  #src = fetchPypi {
  #  inherit pname version;
  #  sha256 = "5dadd54bec98d52cd9f43fb095015c346135b8cafaa35f24c7309cc25d3ad266";
  #};

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "msrest-for-python";
    rev = "v${version}";
    sha256 = "0ilrc06qq0dw4qqzq1dq2vs6nymc39h19w52dwcyawwfalalnjzi";
  };

  propagatedBuildInputs = [
    requests requests_oauthlib isodate certifi
    # optional
    aiohttp aiodns
  ];

  checkInputs = [ pytest httpretty ];

  checkPhase = ''
    pytest tests/
  '';

  meta = with lib; {
    description = "The runtime library 'msrest' for AutoRest generated Python clients.";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.mit;
    maintainers = with maintainers; [ bendlas ];
  };
}
