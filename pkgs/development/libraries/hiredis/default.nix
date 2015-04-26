{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "hiredis-${version}";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${version}";
    sha256 = "195ih8jprw0q253nvhnmfv9dsm8pss6pdf4x3c88q4mfsyw8pg76";
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
