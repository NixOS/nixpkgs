{ lib, fetchPypi, buildPythonPackage, isPy3k, keyring, pbkdf2, pyaes}:
buildPythonPackage rec {
  pname = "browser-cookie3";
  version = "0.7.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f24hsclg1wz2i8aiam91l06qqy0plxhwl615l4qkg35mbw4ry7h";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ keyring pbkdf2 pyaes ];

  # No tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Loads cookies from your browser into a cookiejar object";
    maintainers = with maintainers; [ borisbabic ];
    homepage = https://github.com/borisbabic/browser_cookie3;
    license = licenses.gpl3;
  };
}
