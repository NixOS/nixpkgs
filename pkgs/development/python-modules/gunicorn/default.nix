{ stdenv, buildPythonPackage, fetchPypi
, pytest, mock, pytestcov, coverage }:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "19.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc59005979efb6d2dd7d5ba72d99f8a8422862ad17ff3a16e900684630dd2a10";
  };

  checkInputs = [ pytest mock pytestcov coverage ];

  prePatch = ''
    substituteInPlace requirements_test.txt --replace "==" ">=" \
      --replace "coverage>=4.0,<4.4" "coverage"
  '';

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/gunicorn;
    description = "WSGI HTTP Server for UNIX";
    license = licenses.mit;
  };
}
