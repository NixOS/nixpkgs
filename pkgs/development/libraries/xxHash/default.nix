{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "xxHash-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Cyan4973";
    repo = "xxHash";
    rev = "v${version}";
    sha256 = "19iyr7x0s7in9kp9wrj4iimdx58nv6jndz9x5ndnl07gd90y7jxb";
  };

  outputs = [ "out" "dev" ];

  makeFlags = [ "PREFIX=$(out)" "INCLUDEDIR=$(dev)/include" ];

  meta = with stdenv.lib; {
    description = "Extremely fast hash algorithm";
    longDescription = ''
      xxHash is an Extremely fast Hash algorithm, running at RAM speed limits.
      It successfully completes the SMHasher test suite which evaluates
      collision, dispersion and randomness qualities of hash functions. Code is
      highly portable, and hashes are identical on all platforms (little / big
      endian).
    '';
    homepage = https://github.com/Cyan4973/xxHash;
    license = with licenses; [ bsd2 gpl2 ];
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}
