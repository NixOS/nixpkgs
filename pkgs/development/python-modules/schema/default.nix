{ stdenv, buildPythonPackage, fetchPypi, contextlib2, pytest, mock }:

buildPythonPackage rec {

  pname = "schema";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c9dc8f4624e287c7d1435f8fd758f6a0aabbb7eff442db9192cd46f0e2b6d959";
  };

  preConfigure = ''
    substituteInPlace requirements.txt --replace '==' '>='
  '';

  propagatedBuildInputs = [ contextlib2 ];

  checkInputs = [ pytest mock ];
  checkPhase = "pytest ./test_schema.py";

  meta = with stdenv.lib; {
    description = "Library for validating Python data structures";
    homepage = https://github.com/keleshev/schema;
    license = licenses.mit;
    maintainers = [ maintainers.tobim ];
  };
}
