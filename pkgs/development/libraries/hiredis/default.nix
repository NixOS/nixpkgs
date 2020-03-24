{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hiredis";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${version}";
    sha256 = "1r93ssniiv610pj6d78i1cngism0cdv2k8cmzy7jf9klf76jiwfq";
  };

  PREFIX = "\${out}";

  meta = with stdenv.lib; {
    homepage = "https://github.com/redis/hiredis";
    description = "Minimalistic C client for Redis >= 1.2";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
