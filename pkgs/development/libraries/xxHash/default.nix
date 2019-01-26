{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "xxHash-${version}";
  version = "0.6.4.20171222";

  src = fetchFromGitHub {
    sha256 = "1az5vm14rdc3pa3l0wj180wpii14if16diril3gz8q9ip1215gwj";
    rev = "7caf8bd76440c75dfe1070d3acfbd7891aea8fca";
    repo = "xxHash";
    owner = "Cyan4973";
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
