{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "23.2.6";
  sha256 = "sha256-G930sNbr8h5ryI/IE+J6OKhR5ij68ZhGo1YIEjSOwGU=";
}
