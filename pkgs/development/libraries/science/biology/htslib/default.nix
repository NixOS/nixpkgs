{ lib, stdenv, fetchurl, zlib, bzip2, xz, curl, perl }:

stdenv.mkDerivation rec {
  pname = "htslib";
  version = "1.11";

  src = fetchurl {
    url = "https://github.com/samtools/htslib/releases/download/${version}/${pname}-${version}.tar.bz2";
    sha256 = "1mrq4mihzx37yqhj3sfz6da6mw49niia808bzsw2gkkgmadxvyng";
  };

  # perl is only used during the check phase.
  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib bzip2 xz curl ];

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
