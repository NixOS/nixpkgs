{ stdenv, fetchurl, fetchpatch, libxml2, findXMLCatalogs
, pythonSupport ? true, python2
}:

assert pythonSupport -> python2 != null;
assert pythonSupport -> libxml2.pythonSupport;

stdenv.mkDerivation rec {
  name = "libxslt-1.1.29";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "1klh81xbm9ppzgqk339097i39b7fnpmlj8lzn8bpczl3aww6x5xm";
  };

  patches = stdenv.lib.optional stdenv.isSunOS ./patch-ah.patch;

  outputs = [ "bin" "dev" "out" "doc" ] ++ stdenv.lib.optional pythonSupport "py";

  buildInputs = [ libxml2.dev ] ++ stdenv.lib.optionals pythonSupport [ libxml2.py python2 ];

  propagatedBuildInputs = [ findXMLCatalogs ];

  configureFlags = [
    "--without-crypto"
    "--without-debug"
    "--without-mem-debug"
    "--without-debugger"
  ] ++ stdenv.lib.optional pythonSupport "--with-python=${python2}";

  postFixup = ''
    moveToOutput bin/xslt-config "$dev"
    moveToOutput lib/xsltConf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '' + stdenv.lib.optionalString pythonSupport ''
    mkdir -p $py/nix-support
    echo ${libxml2.py} >> $py/nix-support/propagated-native-build-inputs
    moveToOutput lib/python2.7 "$py"
  '';

  passthru = {
    inherit pythonSupport;
  };

  meta = with stdenv.lib; {
    homepage = http://xmlsoft.org/XSLT/;
    description = "A C library and tools to do XSL transformations";
    license = "bsd";
    platforms = platforms.unix;
    maintainers = [ maintainers.eelco ];
  };
}
