{ lib, buildPythonPackage, fetchPypi, contextlib2, pytest, mock }:

buildPythonPackage rec {

  pname = "schema";
  version = "0.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197";
  };

  preConfigure = ''
    substituteInPlace requirements.txt --replace '==' '>='
  '';

  propagatedBuildInputs = [ contextlib2 ];

  checkInputs = [ pytest mock ];
  checkPhase = "pytest ./test_schema.py";

  meta = with lib; {
    description = "Library for validating Python data structures";
    homepage = "https://github.com/keleshev/schema";
    license = licenses.mit;
    maintainers = [ maintainers.tobim ];
  };
}
