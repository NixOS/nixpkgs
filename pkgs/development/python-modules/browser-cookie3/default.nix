{ lib, fetchPypi, buildPythonPackage, isPy3k, keyring, pbkdf2, pyaes}:
buildPythonPackage rec {
  pname = "browser-cookie3";
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16nghwsrv08gz4iiyxsy5lgg5ljgrwkp471m7xnsvhhpb3axmnsc";
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
