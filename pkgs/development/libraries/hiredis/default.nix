{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "hiredis-${version}";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${version}";
    sha256 = "0ik38lwpmm780jqrry95ckf6flmvd172444p3q8d1k9n99jwij9c";
  };

  PREFIX = "\${out}";

  meta = with stdenv.lib; {
    homepage = https://github.com/redis/hiredis;
    description = "Minimalistic C client for Redis >= 1.2";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
