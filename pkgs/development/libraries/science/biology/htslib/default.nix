{ stdenv, fetchurl, zlib, bzip2, lzma, curl, perl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "htslib";
  version = "1.7";

  src = fetchurl {
    url = "https://github.com/samtools/htslib/releases/download/${version}/${name}.tar.bz2";
    sha256 = "be3d4e25c256acdd41bebb8a7ad55e89bb18e2fc7fc336124b1e2c82ae8886c6";
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
    maintainers = [ maintainers.mimadrid ];
  };
}
