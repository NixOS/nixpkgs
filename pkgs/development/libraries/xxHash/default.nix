{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "xxHash-${version}";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "Cyan4973";
    repo = "xxHash";
    rev = "v${version}";
    sha256 = "137hifc3f3cb4ib64rd6y83arc9hmbyncgrij2v8m94mx66g2aks";
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
    platforms = platforms.unix;
  };
}
