{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hiredis";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${version}";
    sha256 = "sha256-ZxUITm3OcbERcvaNqGQU46bEfV+jN6safPalG0TVfBg=";
  };

  PREFIX = "\${out}";

  meta = with lib; {
    homepage = "https://github.com/redis/hiredis";
    description = "Minimalistic C client for Redis >= 1.2";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
