{ stdenv, buildPythonPackage, fetchPypi,
  pytest }:

buildPythonPackage rec {
  pname = "rfc3986";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jprl2zm3pw2rfbda9rhg3v5bm8q36b8c9i4k8znimlf1mv8bcic";
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
