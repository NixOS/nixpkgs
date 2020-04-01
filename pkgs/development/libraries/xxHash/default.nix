{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "xxHash";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "Cyan4973";
    repo = "xxHash";
    rev = "v${version}";
    sha256 = "0bin0jch6lbzl4f8y052a7azfgq2n7iwqihzgqmcccv5vq4vcx5a";
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
    homepage = "https://github.com/Cyan4973/xxHash";
    license = with licenses; [ bsd2 gpl2 ];
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}
