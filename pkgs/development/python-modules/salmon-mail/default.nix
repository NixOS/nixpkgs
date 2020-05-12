{ stdenv, buildPythonPackage, fetchPypi, dnspython, chardet, lmtpd
, python-daemon, six, jinja2, mock, click }:

buildPythonPackage rec {
  pname = "salmon-mail";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q2m6xri1b7qv46rqpv2qfdgk2jvswj8lpaacnxwjna3m685fhfx";
  };

  checkInputs = [ jinja2 mock ];
  propagatedBuildInputs = [ chardet dnspython lmtpd python-daemon six click ];

  # Darwin tests fail without this. See:
  # https://github.com/NixOS/nixpkgs/pull/82166#discussion_r399909846
  __darwinAllowLocalNetworking = true;

  # The tests use salmon executable installed by salmon itself so we need to add
  # that to PATH
  checkPhase = ''
    PATH=$out/bin:$PATH python setup.py test
  '';

  meta = with stdenv.lib; {
    homepage = "https://salmon-mail.readthedocs.org/";
    description = "Pythonic mail application server";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jluttine ];
  };
}
