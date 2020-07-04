{ stdenv, buildPythonPackage, fetchPypi, contextlib2, pytest, mock }:

buildPythonPackage rec {

  pname = "schema";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b536f2375b49fdf56f36279addae98bd86a8afbd58b3c32ce363c464bed5fc1c";
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
