{ stdenv, buildPythonPackage, fetchPypi, idna, pytestCheckHook }:

buildPythonPackage rec {
  pname = "rfc3986";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17dvx15m3r49bmif5zlli8kzjd6bys6psixzbp14sd5367d9h8qi";
  };

  propagatedBuildInputs = [ idna ];

  checkInputs = [ pytestCheckHook ];

  meta = with stdenv.lib; {
    description = "Validating URI References per RFC 3986";
    homepage = "https://rfc3986.readthedocs.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
