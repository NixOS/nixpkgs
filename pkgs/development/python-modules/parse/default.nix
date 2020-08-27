{ stdenv, fetchPypi
, buildPythonPackage, python
}:
buildPythonPackage rec {
  pname = "parse";
  version = "1.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd89e57aed38dcf3e0ff8253f53121a3b23e6181758993323658bffc048a5c19";
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
