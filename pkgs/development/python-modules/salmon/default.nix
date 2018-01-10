{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder, nose, dnspython
,  chardet, lmtpd, pythondaemon, six, jinja2, mock }:

buildPythonPackage rec {
  pname = "salmon";
  version = "3.0.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "moggers87";
    repo = "salmon";
    rev = version;
    sha256 = "0ffnvvms9w5b2hkwq0ss018vadg5n7xwhc51dlrfynddhrf9p3m3";
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
