{ stdenv, fetchurl, zlib, bzip2, lzma, curl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "${major}.0";
  pname = "htslib";
  major = "1.5";

  src = fetchurl {
    url = "https://github.com/samtools/htslib/releases/download/${major}/htslib-${major}.tar.bz2";
    sha256 = "0bcjmnbwp2bib1z1bkrp95w9v2syzdwdfqww10mkb1hxlmg52ax0";
  };

  buildInputs = [ zlib bzip2 lzma curl ];

  configureFlags = "--enable-libcurl"; # optional but strongly recommended

  installFlags = "prefix=$(out)";

  meta = with stdenv.lib; {
    description = "A C library for reading/writing high-throughput sequencing data";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}

