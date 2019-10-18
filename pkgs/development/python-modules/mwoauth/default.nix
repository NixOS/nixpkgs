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
  version = "0.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7e4c56561a280e14ca4cc20b79ba4a9dd4ec752ff4c797cf29dad4460fb7832";
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
