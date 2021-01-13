{ lib, fetchPypi, buildPythonPackage, isPy3k, lz4, keyring, pbkdf2, pycryptodome, pyaes}:

buildPythonPackage rec {
  pname = "browser-cookie3";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5f26422091ad0e97375d565f8fbacfaf314d0722db35c921635eab23686e4fc4";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ lz4 keyring pbkdf2 pyaes pycryptodome ];

  # No tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Loads cookies from your browser into a cookiejar object";
    maintainers = with maintainers; [ borisbabic ];
    homepage = "https://github.com/borisbabic/browser_cookie3";
    license = licenses.gpl3;
  };
}
