{ lib, stdenv, buildPythonPackage, fetchPypi, pytest, hypothesis, zope_interface
, pympler, coverage, six, clang }:

buildPythonPackage rec {
  pname = "attrs";
  version = "18.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10cbf6e27dbce8c30807caf056c8eb50917e0eaafe86347671b57254006c3e69";
  };

  # macOS needs clang for testing
  checkInputs = [
    pytest hypothesis zope_interface pympler coverage six
  ] ++ lib.optionals (stdenv.isDarwin) [ clang ];

  checkPhase = ''
    py.test
  '';

  # To prevent infinite recursion with pytest
  doCheck = false;

  meta = with lib; {
    description = "Python attributes without boilerplate";
    homepage = https://github.com/hynek/attrs;
    license = licenses.mit;
  };
}
