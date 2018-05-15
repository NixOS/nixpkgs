{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cookies";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13pfndz8vbk4p2a44cfbjsypjarkrall71pgc97glk5fiiw9idnn";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Friendlier RFC 6265-compliant cookie parser/renderer";
    homepage = https://github.com/sashahart/cookies;
    license = licenses.mit;
  };
}
