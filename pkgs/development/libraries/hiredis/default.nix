{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hiredis";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${version}";
    sha256 = "0a55zk3qrw9yl27i87h3brg2hskmmzbfda77dhq9a4if7y70xnfb";
  };

  PREFIX = "\${out}";

  meta = with lib; {
    homepage = "https://github.com/redis/hiredis";
    description = "Minimalistic C client for Redis >= 1.2";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
