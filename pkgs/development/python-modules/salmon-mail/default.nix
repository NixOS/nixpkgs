{ stdenv, buildPythonPackage, fetchPypi, nose, dnspython
,  chardet, lmtpd, python-daemon, six, jinja2, mock }:

buildPythonPackage rec {
  pname = "salmon-mail";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb2f9c3bf2b9f8509453ca8bc06f504350e19488eb9d3d6a4b9e4b8c160b527d";
  };

  # Salmon mail has some issues with python-daemon which is why they set an
  # upper bound for the version. See:
  # https://github.com/moggers87/salmon/issues/90
  # https://github.com/moggers87/salmon/blob/3.1.0/setup.py#L10
  #
  # Anyway, those issues seem to be related to installation only, as far as I
  # understand, so let's just remove the version upper bound.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "python-daemon<2.2.0" "python-daemon"
  '';

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
