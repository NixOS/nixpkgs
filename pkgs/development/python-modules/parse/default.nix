{ stdenv, fetchPypi, fetchpatch
, buildPythonPackage, python
}:
buildPythonPackage rec {
  pname = "parse";
  version = "1.8.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lj9v1q4imszyhvipb6drsm3xdl35nan011mqxxas1yaypixsj40";
  };

  checkPhase = ''
    ${python.interpreter} test_parse.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/r1chardj0n3s/parse;
    description = "parse() is the opposite of format()";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ alunduil ];
  };
}
