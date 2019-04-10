{ lib
, buildPythonPackage
, six
, pyjwt
, requests
, oauthlib
, requests_oauthlib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mwoauth";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a57a315732733240e9522d3c4e370cbdf2c045d00fe0dab433d6119fa09038f";
  };

  # package has no tests
  doCheck = false;
  
  propagatedBuildInputs = [ six pyjwt requests oauthlib requests_oauthlib ];

  meta = with lib; {
    description = "A library designed to provide a simple means to performing an OAuth handshake with a MediaWiki installation with the OAuth Extension installed.";
    homepage =  https://github.com/mediawiki-utilities/python-mwoauth;
    license = licenses.mit;
    maintainers = with maintainers; [ ixxie ];
  };
}
