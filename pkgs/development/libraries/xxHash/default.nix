{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "xxHash";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Cyan4973";
    repo = "xxHash";
    rev = "v${version}";
    sha256 = "0hpbzdd6kfki5f61g103vp7pfczqkdj0js63avl0ss552jfb8h96";
  };

  outputs = [ "out" "dev" ];

  makeFlags = [ "PREFIX=$(dev)" "EXEC_PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Extremely fast hash algorithm";
    longDescription = ''
      xxHash is an Extremely fast Hash algorithm, running at RAM speed limits.
      It successfully completes the SMHasher test suite which evaluates
      collision, dispersion and randomness qualities of hash functions. Code is
      highly portable, and hashes are identical on all platforms (little / big
      endian).
    '';
    homepage = "https://github.com/Cyan4973/xxHash";
    license = with licenses; [ bsd2 gpl2 ];
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}
