{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "xxHash-${version}";
  version = "0.6.3.20171018";

  src = fetchFromGitHub {
    sha256 = "0061ivxpx0p24m4vg7kfx9fs9f0jxvv4g76bmyss5gp90p05hc18";
    rev = "333804ccf0c0339451accac023deeab9e5f7c002";
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
