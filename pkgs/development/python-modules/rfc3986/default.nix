{ stdenv, buildPythonPackage, fetchPypi,
  pytest }:

buildPythonPackage rec {
  pname = "rfc3986";
  version = "1.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2faacfabcc13ed89b061b5f21cbbf330f82400654b317b5907d311c3478ec4c4";
  };

  buildInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = https://rfc3986.readthedocs.org;
    license = licenses.asl20;
    description = "Validating URI References per RFC 3986";
  };
}
