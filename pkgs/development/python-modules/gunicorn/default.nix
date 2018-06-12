{ stdenv, buildPythonPackage, fetchurl
, pytest, mock, pytestcov, coverage }:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "19.8.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/g/gunicorn/${name}.tar.gz";
    sha256 = "bc59005979efb6d2dd7d5ba72d99f8a8422862ad17ff3a16e900684630dd2a10";
  };

  buildInputs = [ pytest mock pytestcov coverage ];

  prePatch = ''
    substituteInPlace requirements_test.txt --replace "==" ">="
  '';

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/gunicorn;
    description = "WSGI HTTP Server for UNIX";
    license = licenses.mit;
  };
}
