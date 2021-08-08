{ lib, fetchPypi, buildPythonPackage, isPy3k, lz4, keyring, pbkdf2, pycryptodome, pyaes}:

buildPythonPackage rec {
  pname = "browser-cookie3";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72c1e6aa6a98adab3a6797b889664bdbfddc287474dd8e774da37a854ec32185";
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
