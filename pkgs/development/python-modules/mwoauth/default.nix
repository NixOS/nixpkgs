{
  lib,
  buildPythonPackage,
  fetchPypi,
  oauthlib,
  pyjwt,
  requests,
  requests-oauthlib,
  six,
}:

buildPythonPackage rec {
  pname = "mwoauth";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IuNAPnSOcBRvjszBQw/lQsn5xP9nfv9CSlLmRPbY98U=";
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

  pythonImportsCheck = [ "mwoauth" ];

  meta = {
    description = "Python library to perform OAuth handshakes with a MediaWiki installation";
    homepage = "https://github.com/mediawiki-utilities/python-mwoauth";
    license = lib.licenses.mit;
  };
}
