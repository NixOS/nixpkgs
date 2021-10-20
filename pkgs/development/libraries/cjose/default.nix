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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "cjose";
    rev = version;
    sha256 = "1msyjwmylb5c7jc16ryx3xb9cdwx682ihsm0ni766y6dfwx8bkhp";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config doxygen ];
  buildInputs = [ jansson openssl ];
  checkInputs = [ check ];

  configureFlags = [
    "--with-jansson=${jansson}"
    "--with-openssl=${openssl.dev}"
  ];

  meta = with lib; {
    homepage = "https://github.com/cisco/cjose";
    changelog = "https://github.com/cisco/cjose/blob/${version}/CHANGELOG.md";
    description = "C library for Javascript Object Signing and Encryption";
    license = licenses.mit;
    maintainers = with maintainers; [ midchildan ];
    platforms = platforms.all;
  };
}
