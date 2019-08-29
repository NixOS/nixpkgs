{ stdenv, buildPythonPackage, fetchPypi,
  pytest }:

buildPythonPackage rec {
  pname = "rfc3986";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0344d0bd428126ce554e7ca2b61787b6a28d2bbd19fc70ed2dd85efe31176405";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    homepage = https://rfc3986.readthedocs.org;
    license = licenses.asl20;
    description = "Validating URI References per RFC 3986";
  };
}
