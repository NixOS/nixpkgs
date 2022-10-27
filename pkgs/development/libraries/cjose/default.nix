{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, doxygen
, check
, jansson
, openssl
}:

stdenv.mkDerivation rec {
  pname = "cjose";
  version = "0.6.2.1";

  src = fetchFromGitHub {
    owner = "zmartzone";
    repo = "cjose";
    rev = "v${version}";
    sha256 = "sha256-QgSO4jFouowDJeUTT4kUEXD+ctQ7JiY/5DkiPyb+Z/I=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config doxygen ];
  buildInputs = [ jansson openssl ];
  checkInputs = [ check ];

  configureFlags = [
    "--with-jansson=${jansson}"
    "--with-openssl=${openssl.dev}"
  ];

  meta = with lib; {
    homepage = "https://github.com/zmartzone/cjose";
    changelog = "https://github.com/zmartzone/cjose/blob/${version}/CHANGELOG.md";
    description = "C library for Javascript Object Signing and Encryption. This is a maintained fork of the original project";
    license = licenses.mit;
    maintainers = with maintainers; [ midchildan ];
    platforms = platforms.all;
  };
}
