{ lib, fetchPypi, buildPythonPackage, isPy3k, keyring, pbkdf2, pyaes}:
buildPythonPackage rec {
  pname = "browser-cookie3";
  version = "0.11.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d140c6b651dbd8b8555aca6472557fcfda4dd93afc26ea3a200be922a843e2c";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ keyring pbkdf2 pyaes ];

  # No tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Loads cookies from your browser into a cookiejar object";
    maintainers = with maintainers; [ borisbabic ];
    homepage = "https://github.com/borisbabic/browser_cookie3";
    license = licenses.gpl3;
  };
}
