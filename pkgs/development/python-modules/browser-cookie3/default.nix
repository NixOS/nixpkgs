{ lib
, fetchFromGitHub
, buildPythonPackage
, isPy27
, keyring
, pbkdf2
, pyaes
, python-lz4
, configparser
}:

buildPythonPackage rec {
  pname = "browser-cookie3";
  version = "0.9.1";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "borisbabic";
    repo = "browser_cookie3";
    rev = version;
    sha256 = "00967fw9d2zb7kzr7p0lvkhi0vswy1crznxqgq8z2pk229cn4b2s";
  };

  propagatedBuildInputs = [
    keyring
    pbkdf2
    pyaes
    python-lz4
    configparser
  ];

  # No tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Loads cookies from your browser into a cookiejar object";
    maintainers = with maintainers; [ borisbabic ];
    homepage = https://github.com/borisbabic/browser_cookie3;
    license = licenses.gpl3;
  };
}
