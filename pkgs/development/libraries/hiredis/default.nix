{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hiredis";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${version}";
    sha256 = "sha256-0ESRnZTL6/vMpek+2sb0YQU3ajXtzj14yvjfOSQYjf4=";
  };

  PREFIX = "\${out}";

  meta = with lib; {
    homepage = "https://github.com/redis/hiredis";
    description = "Minimalistic C client for Redis >= 1.2";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
