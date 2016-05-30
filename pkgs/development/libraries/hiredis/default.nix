{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "hiredis-${version}";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${version}";
    sha256 = "1qxiv61bsp6s847hhkxqj7vnbdlac089r2qdp3zgxhhckaflhb7r";
  };

  PREFIX = "\${out}";

  meta = with stdenv.lib; {
    homepage = https://github.com/redis/hiredis;
    description = "Minimalistic C client for Redis >= 1.2";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
