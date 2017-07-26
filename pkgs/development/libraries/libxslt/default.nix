{ stdenv, fetchurl, fetchpatch, libxml2, findXMLCatalogs, python2
, buildPlatform, hostPlatform
, cryptoSupport ? false
, pythonSupport ? buildPlatform == hostPlatform
}:

assert pythonSupport -> python2 != null;
assert pythonSupport -> libxml2.pythonSupport;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libxslt-1.1.29";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "1klh81xbm9ppzgqk339097i39b7fnpmlj8lzn8bpczl3aww6x5xm";
  };

  patches = stdenv.lib.optional stdenv.isSunOS ./patch-ah.patch;

  # fixes: can't build x86_64-unknown-cygwin shared library unless -no-undefined is specified
  postPatch = optionalString hostPlatform.isCygwin ''
    substituteInPlace tests/plugins/Makefile.in \
      --replace 'la_LDFLAGS =' 'la_LDFLAGS = $(WIN32_EXTRA_LDFLAGS)'
  '';

  outputs = [ "bin" "dev" "out" "doc" ] ++ stdenv.lib.optional pythonSupport "py";

  buildInputs = [ libxml2.dev ] ++ stdenv.lib.optionals pythonSupport [ libxml2.py python2 ];

  propagatedBuildInputs = [ findXMLCatalogs ];

  # TODO move cryptoSupport as last flag, when upgrading libxslt
  configureFlags = optional (!cryptoSupport) "--without-crypto" ++ [
    "--without-debug"
    "--without-mem-debug"
    "--without-debugger"
  ] ++ optional pythonSupport "--with-python=${python2}";

  postFixup = ''
    moveToOutput bin/xslt-config "$dev"
    moveToOutput lib/xsltConf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '' + optionalString pythonSupport ''
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
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.eelco ];
  };
}
