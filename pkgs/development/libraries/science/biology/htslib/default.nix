{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "htslib";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/samtools/${pname}/releases/download/${version}/${name}.tar.bz2";
    sha256 = "49d53a2395b8cef7d1d11270a09de888df8ba06f70fe68282e8235ee04124ae6";
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

