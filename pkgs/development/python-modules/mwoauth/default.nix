{ lib
, buildPythonPackage
, fetchPypi
, oauthlib
, pyjwt
, pythonOlder
, requests
, requests-oauthlib
, six
}:

buildPythonPackage rec {
  pname = "mwoauth";
  version = "0.3.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CNr07auqD5WoRfmOVwfecxaoODqWJfIK52iwNZkcNqw=";
  };

  propagatedBuildInputs = [
    oauthlib
    pyjwt
    requests
    requests-oauthlib
    six
  ];

  # PyPI source has no tests included
  # https://github.com/mediawiki-utilities/python-mwoauth/issues/44
  doCheck = false;

  pythonImportsCheck = [
    "mwoauth"
  ];

  meta = with lib; {
    description = "Python library to perform OAuth handshakes with a MediaWiki installation";
    homepage = "https://github.com/mediawiki-utilities/python-mwoauth";
    license = licenses.mit;
    maintainers = with maintainers; [ ixxie ];
  };
}
