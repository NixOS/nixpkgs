{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "hiredis-${version}";
  version = "0.12.1";

  src = fetchgit {
    url = "git://github.com/redis/hiredis";
    rev = "37c06facda57af9bad68f50c18edfa22d6ef76f7";
    sha256 = "1z1rzhh1659g8i5bl78k1i1imlz2prwirhzbkn6j7hvq4mxbf2yz";
  };

  PREFIX = "\${out}";

  meta = with stdenv.lib; {
    homepage = https://github.com/redis/hiredis;
    description = "Minimalistic C client for Redis >= 1.2";
    licenses = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
