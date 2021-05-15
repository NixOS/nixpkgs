{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hiredis";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${version}";
    sha256 = "01xnynm9d56a0alb5wxbfayakybm5pnr12icj9mqkn4xxihbnbgr";
  };

  PREFIX = "\${out}";

  meta = with lib; {
    homepage = "https://github.com/redis/hiredis";
    description = "Minimalistic C client for Redis >= 1.2";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
