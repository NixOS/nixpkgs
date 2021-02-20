{ lib, buildPythonPackage, fetchPypi, contextlib2, pytest, mock }:

buildPythonPackage rec {

  pname = "schema";
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fbb6a52eb2d9facf292f233adcc6008cffd94343c63ccac9a1cb1f3e6de1db17";
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
