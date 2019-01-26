{ stdenv, fetchPypi
, buildPythonPackage, python
}:
buildPythonPackage rec {
  pname = "parse";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9dd6048ea212cd032a342f9f6aa2b7bc222f7407c7e37bdc2777fecd36897437";
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
