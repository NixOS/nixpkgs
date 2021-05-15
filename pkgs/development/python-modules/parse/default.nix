{ lib, fetchPypi
, buildPythonPackage, python
}:
buildPythonPackage rec {
  pname = "parse";
  version = "1.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ff82852bcb65d139813e2a5197627a94966245c897796760a3a2a8eb66f020b";
  };

  checkPhase = ''
    ${python.interpreter} test_parse.py
  '';

  meta = with lib; {
    homepage = "https://github.com/r1chardj0n3s/parse";
    description = "parse() is the opposite of format()";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ alunduil ];
  };
}
