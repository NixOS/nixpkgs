{ stdenv, fetchurl, zlib, bzip2, lzma, curl, perl }:

stdenv.mkDerivation rec {
  pname = "htslib";
  version = "1.9";

  src = fetchurl {
    url = "https://github.com/samtools/htslib/releases/download/${version}/${pname}-${version}.tar.bz2";
    sha256 = "16ljv43sc3fxmv63w7b2ff8m1s7h89xhazwmbm1bicz8axq8fjz0";
  };

  # perl is only used during the check phase.
  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib bzip2 lzma curl ];

  configureFlags = [ "--enable-libcurl" ]; # optional but strongly recommended

  installFlags = "prefix=$(out)";

  preCheck = ''
    patchShebangs test/
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A C library for reading/writing high-throughput sequencing data";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
  };
}
