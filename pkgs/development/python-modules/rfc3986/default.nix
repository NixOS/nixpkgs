{ stdenv, buildPythonPackage, fetchPypi,
  pytest }:

buildPythonPackage rec {
  pname = "rfc3986";
  version = "0.4.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ac85eb132fae7bbd811fa48d11984ae3104be30d44d397a351d004c633a68d2";
  };

  buildInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = "https://rfc3986.readthedocs.org";
    license = licenses.asl20;
    description = "Validating URI References per RFC 3986";
  };
}
