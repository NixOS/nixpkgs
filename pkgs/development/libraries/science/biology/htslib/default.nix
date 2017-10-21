{ stdenv, fetchurl, zlib, bzip2, lzma, curl, perl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "htslib";
  version = "1.6";

  src = fetchurl {
    url = "https://github.com/samtools/htslib/releases/download/${version}/${name}.tar.bz2";
    sha256 = "1jsca3hg4rbr6iqq6imkj4lsvgl8g9768bcmny3hlff2w25vx24m";
  };

  # perl is only used during the check phase.
  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib bzip2 lzma curl ];

  configureFlags = "--enable-libcurl"; # optional but strongly recommended

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
