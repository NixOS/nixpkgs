{ stdenv, buildPythonPackage, fetchPypi,
  pytest }:

buildPythonPackage rec {
  pname = "rfc3986";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qf4dyxvjs7mxrxc0gr7gzyn4iflb2wgq01r5pzrxac8rnvy8fmw";
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
