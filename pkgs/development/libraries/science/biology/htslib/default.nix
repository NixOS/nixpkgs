{ stdenv, fetchurl, zlib, bzip2, lzma, curl, perl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "${major}.0";
  pname = "htslib";
  major = "1.6";

  src = fetchurl {
    url = "https://github.com/samtools/htslib/releases/download/${major}/htslib-${major}.tar.bz2";
    sha256 = "1jsca3hg4rbr6iqq6imkj4lsvgl8g9768bcmny3hlff2w25vx24m";
  };

  propagatedNativeBuildInputs = [ perl ];

  buildInputs = [ zlib bzip2 lzma curl ];

  configureFlags = "--enable-libcurl"; # optional but strongly recommended

  installFlags = "prefix=$(out)";

  enableParallelBuilding = true;

  doCheck = true;

  preCheck = ''
    find test -name "*.pl" -exec sed -ie 's|/usr/bin/\(env[[:space:]]\)\{0,1\}perl|${perl}/bin/perl|' {} +
  '';

  meta = with stdenv.lib; {
    description = "A C library for reading/writing high-throughput sequencing data";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}

