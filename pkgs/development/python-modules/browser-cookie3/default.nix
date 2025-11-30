{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  lz4,
  keyring,
  pbkdf2,
  pycryptodomex,
  pyaes,
}:

buildPythonPackage rec {
  pname = "browser-cookie3";
  version = "0.20.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "borisbabic";
    repo = "browser_cookie3";
    tag = version;
    hash = "sha256-3EmFx+9LQFuS26mUPH/etc6hkUXqmNOOipbldhjorDE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lz4
    keyring
    pbkdf2
    pyaes
    pycryptodomex
  ];

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [ "browser_cookie3" ];

  meta = with lib; {
    description = "Loads cookies from your browser into a cookiejar object";
    homepage = "https://github.com/borisbabic/browser_cookie3";
    changelog = "https://github.com/borisbabic/browser_cookie3/blob/master/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ borisbabic ];
  };
}
