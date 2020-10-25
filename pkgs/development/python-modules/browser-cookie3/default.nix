{ lib, fetchPypi, buildPythonPackage, isPy3k, keyring, pbkdf2, pyaes}:
buildPythonPackage rec {
  pname = "browser-cookie3";
  version = "0.11.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4435cd0fdad358f8522ed72294b7c3c02f86b24b6d1c6bb1e7f0a53413d3bd3";
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
