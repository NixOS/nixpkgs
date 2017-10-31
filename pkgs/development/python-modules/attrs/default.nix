{ lib, stdenv, buildPythonPackage, fetchPypi, pytest, hypothesis, zope_interface
, pympler, coverage, six, clang }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "attrs";
  version = "17.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04gx08ikpk26wnq22f7l42gapcvk8iz1512r927k6sadz6cinkax";
  };

  # macOS needs clang for testing
  buildInputs = [
    pytest hypothesis zope_interface pympler coverage six
  ] ++ lib.optionals (stdenv.isDarwin) [ clang ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Python attributes without boilerplate";
    homepage = https://github.com/hynek/attrs;
    license = licenses.mit;
  };
}
