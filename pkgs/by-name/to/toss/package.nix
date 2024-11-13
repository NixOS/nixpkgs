{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "toss";
  version = "1.1";
  src = fetchFromGitHub {
    owner = "zerotier";
    repo = pname;
    rev = version;
    sha256 = "05ql0d8wbdhnmh3dw8ch5bi6clfb9h8v21lq2a74iy02slya2y0r";
  };
  preInstall = "export DESTDIR=$out/bin";
  meta = with lib;
    src.meta // {
      description = "Dead simple LAN file transfers from the command line";
      license = with licenses; [ mit ];
      maintainers = with maintainers; [ ehmry ];
      platforms = platforms.unix;
    };
}
