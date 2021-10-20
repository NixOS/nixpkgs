{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, libgcrypt, libbaseencode }:

stdenv.mkDerivation rec {
  pname = "libcotp";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qq4shwiz1if9vys052dnsbm4dfw1ynlj6nsb0v4zjly3ndspfsk";
  };

  buildInputs = [ libbaseencode libgcrypt ];
  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "C library that generates TOTP and HOTP";
    homepage = "https://github.com/paolostivanin/libcotp";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexbakker ];
  };
}
