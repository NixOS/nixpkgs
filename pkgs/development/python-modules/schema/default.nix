{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {

  pname = "schema";
  version = "0.6.7";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "410f44cb025384959d20deef00b4e1595397fa30959947a4f0d92e9c84616f35";
  };

  checkInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "Library for validating Python data structures";
    homepage = https://github.com/keleshev/schema;
    license = licenses.mit;
  };
}
