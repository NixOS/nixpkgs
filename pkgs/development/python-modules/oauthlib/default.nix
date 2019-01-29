{ stdenv
, buildPythonPackage
, fetchurl
, mock
, nose
, unittest2
, cryptography
, blinker
, pyjwt
}:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "oauthlib";

  src = fetchurl {
    url = "https://github.com/idan/oauthlib/archive/v${version}.tar.gz";
    sha256 = "02b645a8rqh4xfs1cmj8sss8wqppiadd1ndq3av1cdjz2frfqcjf";
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
