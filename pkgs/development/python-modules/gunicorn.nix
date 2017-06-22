{ stdenv, buildPythonPackage, fetchurl
, pytest, mock, pytestcov, coverage }:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "19.7.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/g/gunicorn/${name}.tar.gz";
    sha256 = "eee1169f0ca667be05db3351a0960765620dad53f53434262ff8901b68a1b622";
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
