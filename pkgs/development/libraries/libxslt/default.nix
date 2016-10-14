{ stdenv, fetchurl, fetchpatch, libxml2, findXMLCatalogs }:

stdenv.mkDerivation rec {
  name = "libxslt-1.1.29";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "1klh81xbm9ppzgqk339097i39b7fnpmlj8lzn8bpczl3aww6x5xm";
  };

  patches = stdenv.lib.optional stdenv.isSunOS ./patch-ah.patch;

  outputs = [ "bin" "dev" "out" "doc" ];

  buildInputs = [ libxml2 ];

  propagatedBuildInputs = [ findXMLCatalogs ];

  configureFlags = [
    "--without-python"
    "--without-crypto"
    "--without-debug"
    "--without-mem-debug"
    "--without-debugger"
  ];

  postFixup = ''
    moveToOutput bin/xslt-config "$dev"
    moveToOutput lib/xsltConf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '';

  meta = with stdenv.lib; {
    homepage = http://xmlsoft.org/XSLT/;
    description = "A C library and tools to do XSL transformations";
    license = "bsd";
    platforms = platforms.unix;
    maintainers = [ maintainers.eelco ];
  };
}
