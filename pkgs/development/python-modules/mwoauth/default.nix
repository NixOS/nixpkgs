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
  version = "0.3.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ng1wofpvRSWE3hy4U65sEfQSM1SfeDnPuHn5lBD2rUY=";
  };

  propagatedBuildInputs = [
    oauthlib
    pyjwt
    requests
    requests-oauthlib
    six
  ];

  postPatch = ''
    # https://github.com/mediawiki-utilities/python-mwoauth/pull/43
    substituteInPlace setup.py \
      --replace "PyJWT>=1.0.1,<2.0.0" "PyJWT>=1.0.1"
  '';

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
