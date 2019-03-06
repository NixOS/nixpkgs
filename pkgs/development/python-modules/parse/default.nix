{ stdenv, fetchPypi
, buildPythonPackage, python
}:
buildPythonPackage rec {
  pname = "parse";
  version = "1.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "870dd675c1ee8951db3e29b81ebe44fd131e3eb8c03a79483a58ea574f3145c2";
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
