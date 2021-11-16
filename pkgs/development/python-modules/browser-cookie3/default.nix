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
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f8e5ddf5a6641a1fdca12d82b0923777ba59a988b68c9bcf358bfb7c42ef25b";
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
