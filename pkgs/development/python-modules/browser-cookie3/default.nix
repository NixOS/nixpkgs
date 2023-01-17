{ stdenv
, lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, lz4
, keyring
, pbkdf2
, pycryptodomex
, pyaes
}:

buildPythonPackage rec {
  pname = "browser-cookie3";
  version = "0.16.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i2Ib7OGnoimiZ2R/vGe6phPhA8lEP0BJ/gP1q9RVeiU=";
  };

  propagatedBuildInputs = [
    lz4
    keyring
    pbkdf2
    pyaes
    pycryptodomex
  ];

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "browser_cookie3"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Loads cookies from your browser into a cookiejar object";
    homepage = "https://github.com/borisbabic/browser_cookie3";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ borisbabic ];
  };
}
