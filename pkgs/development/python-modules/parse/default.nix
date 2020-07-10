{ stdenv, fetchPypi
, buildPythonPackage, python
}:
buildPythonPackage rec {
  pname = "parse";
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h4m5df5grjpaf087g8ciishz5ajl28s3140s8bngppvy71f5m56";
  };

  checkPhase = ''
    ${python.interpreter} test_parse.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/r1chardj0n3s/parse";
    description = "parse() is the opposite of format()";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ alunduil ];
  };
}
