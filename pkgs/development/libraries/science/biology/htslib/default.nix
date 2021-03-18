{ lib, stdenv, fetchurl, zlib, bzip2, lzma, curl, perl }:

stdenv.mkDerivation rec {
  pname = "htslib";
  version = "1.12";

  src = fetchurl {
    url = "https://github.com/samtools/htslib/releases/download/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-IoAUG0bpU7pK4BuYM1qE+ObMvbbVzbq39w7k9+O29Mo=";
  };

  # perl is only used during the check phase.
  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib bzip2 lzma curl ];

  configureFlags = [ "--enable-libcurl" ]; # optional but strongly recommended

  installFlags = [ "prefix=$(out)" ];

  preCheck = ''
    patchShebangs test/
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "A C library for reading/writing high-throughput sequencing data";
    license = licenses.mit;
    homepage = "http://www.htslib.org/";
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
  };
}
