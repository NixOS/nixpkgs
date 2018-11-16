{ stdenv, buildPythonPackage, fetchPypi,
  pytest }:

buildPythonPackage rec {
  pname = "rfc3986";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8458571c4c57e1cf23593ad860bb601b6a604df6217f829c2bc70dc4b5af941b";
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
