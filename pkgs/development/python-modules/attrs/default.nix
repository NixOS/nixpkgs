{ lib, stdenv, buildPythonPackage, fetchPypi, pytest, hypothesis, zope_interface
, pympler, coverage, six, clang }:

buildPythonPackage rec {
  pname = "attrs";
  version = "20.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "152m77pcxkfwi0l8r0iwn859jx6gsqvxss1nbm6x7qcypgdlvd96";
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
    homepage = "https://github.com/python-attrs/attrs";
    license = licenses.mit;
  };
}
