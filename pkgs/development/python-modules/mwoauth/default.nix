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
  version = "0.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e0d70a1fa6f452584de1cb853ae6c11f41233549f7839cfb879f99410f6ad46";
  };

  propagatedBuildInputs = [
    oauthlib
    pyjwt
    requests
    requests_oauthlib
    six
  ];

  postPatch = ''
    # https://github.com/mediawiki-utilities/python-mwoauth/pull/43
    substituteInPlace setup.py --replace "PyJWT>=1.0.1,<2.0.0" "PyJWT>=1.0.1"
  '';

  # PyPI source has no tests included
  # https://github.com/mediawiki-utilities/python-mwoauth/issues/44
  doCheck = false;

  pythonImportsCheck = [ "mwoauth" ];

  meta = with lib; {
    description = "Python library to perform OAuth handshakes with a MediaWiki installation";
    homepage = "https://github.com/mediawiki-utilities/python-mwoauth";
    license = licenses.mit;
    maintainers = with maintainers; [ ixxie ];
  };
}
