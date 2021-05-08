{ buildPythonPackage
, fetchPypi
, flask
, lib
, oauthlib
, pyjwt
, pytest
, requests
, requests_oauthlib
, six
}:

buildPythonPackage rec {
  pname = "mwoauth";
  version = "0.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e0d70a1fa6f452584de1cb853ae6c11f41233549f7839cfb879f99410f6ad46";
  };

  checkInputs = [ flask pytest ];

  patchPhase = ''
    sed -i 's/PyJWT>=1.0.1,<2.0.0/PyJWT>=1.0.1,<3.0.0/g' setup.py
  '';

  propagatedBuildInputs = [ six pyjwt requests oauthlib requests_oauthlib ];

  meta = with lib; {
    description = "A library designed to provide a simple means to performing an OAuth handshake with a MediaWiki installation with the OAuth Extension installed.";
    homepage =  "https://github.com/mediawiki-utilities/python-mwoauth";
    license = licenses.mit;
    maintainers = with maintainers; [ ixxie ];
  };
}
