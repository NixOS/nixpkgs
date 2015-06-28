{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "hiredis-${version}";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${version}";
    sha256 = "15rzq7n7z9h143smrnd34f9gh24swwal6r9z9xlxsl0jxabiv71l";
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
