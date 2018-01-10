{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder, nose, dnspython
,  chardet, lmtpd, pythondaemon, six, jinja2, mock }:

buildPythonPackage rec {
  pname = "salmon";
  # NOTE: The latest release version 2 is over 3 years old. So let's use some
  # recent commit from master. There will be a new release at some point, then
  # one can change this to use PyPI. See:
  # https://github.com/moggers87/salmon/issues/52
  version = "bec795cdab744be4f103d8e35584dfee622ddab2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "moggers87";
    repo = "salmon";
    rev = version;
    sha256 = "0nx8pyxy7n42nsqqvhd85ycm1i5wlacsi7lwb4rrs9d416bpd300";
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
