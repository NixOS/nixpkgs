{ stdenv, buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "readlike";
  version = "0.1.2";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "08645493a24eecbcad70a5ed7fbf1a3820ba5e57e9690297edc485c2992f66b2";
  };

  # no tests included in PyPi package
  doCheck = false;

  meta = {
    description = "GNU Readline-like line editing module";
    license = stdenv.lib.licenses.mit;
    homepage = https://github.com/jangler/readlike;
    maintainers = with lib.maintainers; [ aswan89 ];
  };
}
