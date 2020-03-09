{ lib, fetchPypi, buildPythonPackage, isPy3k, keyring, pbkdf2, pyaes}:
buildPythonPackage rec {
  pname = "browser-cookie3";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42e73e0276083ff162080860cd039138760921a56a0f316775cecee37d444c3f";
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
