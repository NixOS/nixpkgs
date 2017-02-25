{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "htslib";
  version = "1.3.2";

  src = fetchurl {
    url = "https://github.com/samtools/${pname}/releases/download/${version}/${name}.tar.bz2";
    sha256 = "0iq3blw23s55vkr1z88p9y2dqrb2dybzhl6hz2nlk53ncihrxcdr";
  };

  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    description = "A C library for reading/writing high-throughput sequencing data";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}

