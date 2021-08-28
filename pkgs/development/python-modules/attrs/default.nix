{ lib, stdenv, buildPythonPackage, fetchPypi, pytest, hypothesis, zope_interface
, pympler, coverage, six, clang }:

buildPythonPackage rec {
  pname = "attrs";
  version = "20.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700";
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
