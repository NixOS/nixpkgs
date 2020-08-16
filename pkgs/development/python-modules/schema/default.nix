{ stdenv, buildPythonPackage, fetchPypi, contextlib2, pytest, mock }:

buildPythonPackage rec {

  pname = "schema";
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4cf529318cfd1e844ecbe02f41f7e5aa027463e7403666a52746f31f04f47a5e";
  };

  preConfigure = ''
    substituteInPlace requirements.txt --replace '==' '>='
  '';

  propagatedBuildInputs = [ contextlib2 ];

  checkInputs = [ pytest mock ];
  checkPhase = "pytest ./test_schema.py";

  meta = with stdenv.lib; {
    description = "Library for validating Python data structures";
    homepage = "https://github.com/keleshev/schema";
    license = licenses.mit;
    maintainers = [ maintainers.tobim ];
  };
}
