{ lib, stdenv, buildPythonPackage, fetchPypi, pytest, hypothesis, zope_interface
, pympler, coverage, six, clang }:

buildPythonPackage rec {
  pname = "attrs";
  version = "21.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb";
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
    homepage = "https://github.com/hynek/attrs";
    license = licenses.mit;
  };
}
