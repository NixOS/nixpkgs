{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, nose, dnspython
,  chardet, lmtpd, pythondaemon, six, jinja2, mock }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "salmon-mail";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1smggsnkwiqy8zjq604dkm5g0np27pdnj3szsbn8v4ja84nncq18";
  };

  checkInputs = [ nose jinja2 mock ];
  propagatedBuildInputs = [ chardet dnspython lmtpd pythondaemon six ];

  meta = with stdenv.lib; {
    homepage = http://salmon-mail.readthedocs.org/;
    description = "Pythonic mail application server";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jluttine ];
  };
}
