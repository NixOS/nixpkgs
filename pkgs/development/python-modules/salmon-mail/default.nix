{ stdenv, buildPythonPackage, fetchPypi, nose, dnspython
,  chardet, lmtpd, python-daemon, six, jinja2, mock }:

buildPythonPackage rec {
  pname = "salmon-mail";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb2f9c3bf2b9f8509453ca8bc06f504350e19488eb9d3d6a4b9e4b8c160b527d";
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
