{ stdenv, buildPythonPackage, fetchPypi,
  pytest }:

buildPythonPackage rec {
  pname = "rfc3986";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17dvx15m3r49bmif5zlli8kzjd6bys6psixzbp14sd5367d9h8qi";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    homepage = "https://rfc3986.readthedocs.org";
    license = licenses.asl20;
    description = "Validating URI References per RFC 3986";
  };
}
