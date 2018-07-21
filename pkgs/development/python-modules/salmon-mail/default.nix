{ stdenv, buildPythonPackage, fetchPypi, nose, dnspython
,  chardet, lmtpd, pythondaemon, six, jinja2, mock }:

buildPythonPackage rec {
  pname = "salmon-mail";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "452557172901d6227a325bbc72fcf61002a53c2342d935457b729303dce71f7e";
  };

  checkInputs = [ nose jinja2 mock ];
  propagatedBuildInputs = [ chardet dnspython lmtpd pythondaemon six ];

  # The tests use salmon executable installed by salmon itself so we need to add
  # that to PATH
  checkPhase = ''
    PATH=$out/bin:$PATH nosetests .
  '';

  meta = with stdenv.lib; {
    homepage = http://salmon-mail.readthedocs.org/;
    description = "Pythonic mail application server";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jluttine ];
  };
}
