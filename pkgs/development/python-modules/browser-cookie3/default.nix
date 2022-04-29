{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, lz4
, keyring
, pbkdf2
, pycryptodome
, pyaes
}:

buildPythonPackage rec {
  pname = "browser-cookie3";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kWYMl/JZxonLfT0u/13bXz0MlC36jssWWq/i05FDpOA=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [
    lz4
    keyring
    pbkdf2
    pyaes
    pycryptodome
  ];

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "browser_cookie3"
  ];

  meta = with lib; {
    description = "Loads cookies from your browser into a cookiejar object";
    homepage = "https://github.com/borisbabic/browser_cookie3";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ borisbabic ];
  };
}
