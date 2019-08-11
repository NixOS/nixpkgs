{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {

  pname = "schema";
  version = "0.6.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa1a53fe5f3b6929725a4e81688c250f46838e25d8c1885a10a590c8c01a7b74";
  };

  checkInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "Library for validating Python data structures";
    homepage = https://github.com/keleshev/schema;
    license = licenses.mit;
  };
}
