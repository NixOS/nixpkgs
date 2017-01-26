{ stdenv, buildPythonPackage, fetchurl
, pytest, mock, pytestcov, coverage }:

buildPythonPackage rec {
  name = "gunicorn-19.3.0";

  src = fetchurl {
    url = "mirror://pypi/g/gunicorn/${name}.tar.gz";
    sha256 = "12d0jd9y9fyssc28mn8j6nzrck8y05hc946p5h0rmbc25043bj4b";
  };

  buildInputs = [ pytest mock pytestcov coverage ];

  prePatch = ''
    substituteInPlace requirements_test.txt --replace "==" ">="
  '';

  meta = with stdenv.lib; {
    homepage = http://pypi.python.org/pypi/gunicorn;
    description = "WSGI HTTP Server for UNIX";
    license = licenses.mit;
  };
}
