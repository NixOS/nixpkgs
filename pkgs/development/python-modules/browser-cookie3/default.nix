{ lib, fetchPypi, buildPythonPackage, isPy3k, keyring, pbkdf2, pyaes}:
buildPythonPackage rec {
  pname = "browser-cookie3";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af5cb74fcee3a7b76391cd1eaf653a70b179ed6026cdeba2b3512f09c8ade568";
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
