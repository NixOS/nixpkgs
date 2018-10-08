{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, nose
, unittest2
, cryptography
, blinker
, pyjwt
}:

buildPythonPackage rec {
  version = "2.1.0";
  pname = "oauthlib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac35665a61c1685c56336bda97d5eefa246f1202618a1d6f34fccb1bdd404162";
  };

  buildInputs = [ mock nose unittest2 ];

  propagatedBuildInputs = [ cryptography blinker pyjwt ];

  meta = with stdenv.lib; {
    homepage = https://github.com/idan/oauthlib;
    downloadPage = https://github.com/idan/oauthlib/releases;
    description = "A generic, spec-compliant, thorough implementation of the OAuth request-signing logic";
    maintainers = with maintainers; [ prikhi ];
  };
}
