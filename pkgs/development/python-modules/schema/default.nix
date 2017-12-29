{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {

  pname = "schema";
  version = "0.6.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lw28j9w9vxyigg7vkfkvi6ic9lgjkdnfvnxdr7pklslqvzmk2vm";
  };

  checkInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "Library for validating Python data structures";
    homepage = https://github.com/keleshev/schema;
    license = licenses.mit;
  };
}
