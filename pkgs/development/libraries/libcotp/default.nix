{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, libgcrypt, libbaseencode }:

stdenv.mkDerivation rec {
  pname = "libcotp";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PN0kd0CP2zrkuPTdaS3TdsdEl+Gy6CecrDSh0Bd7mRk=";
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
