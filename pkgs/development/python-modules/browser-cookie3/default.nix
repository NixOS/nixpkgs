{ stdenv
, lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, lz4
, keyring
, pbkdf2
, pycryptodome
, pyaes
}:

buildPythonPackage rec {
  pname = "browser-cookie3";
  version = "0.14.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2cMWFyHK+7M99Z9O7PiKue37c5XVBe/n88AF5ax7A2s=";
  };

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
    broken = stdenv.isDarwin;
    description = "Loads cookies from your browser into a cookiejar object";
    homepage = "https://github.com/borisbabic/browser_cookie3";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ borisbabic ];
  };
}
