{ stdenv, fetchurl, zlib, bzip2, lzma, curl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "${major}.0";
  pname = "htslib";
  major = "1.4";

  src = fetchurl {
    url = "https://github.com/samtools/htslib/releases/download/${major}/htslib-${major}.tar.bz2";
    sha256 = "0l1ki3sqfhawfn7fx9v7i2pm725jki4c5zij9j96xka5zwc8iz2w";
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

