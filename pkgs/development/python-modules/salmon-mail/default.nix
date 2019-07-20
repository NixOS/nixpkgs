{ stdenv, buildPythonPackage, fetchPypi, nose, dnspython
,  chardet, lmtpd, python-daemon, six, jinja2, mock }:

buildPythonPackage rec {
  pname = "salmon-mail";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ddd9nwdmiibk3jaampznm8nai5b7zalp0f8c65l71674300bqnw";
  };

  checkInputs = [ nose jinja2 mock ];
  propagatedBuildInputs = [ chardet dnspython lmtpd python-daemon six ];

  # The tests use salmon executable installed by salmon itself so we need to add
  # that to PATH
  checkPhase = ''
    PATH=$out/bin:$PATH nosetests .
  '';

  meta = with stdenv.lib; {
    homepage = https://salmon-mail.readthedocs.org/;
    description = "Pythonic mail application server";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jluttine ];
  };
}
