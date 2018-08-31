{ stdenv, fetchurl, libxml2, findXMLCatalogs, python2
, cryptoSupport ? false
, pythonSupport ? stdenv.buildPlatform == stdenv.hostPlatform
}:

assert pythonSupport -> python2 != null;
assert pythonSupport -> libxml2.pythonSupport;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "libxslt";
  version = "1.1.32";
  name = pname + "-" + version;

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "0q2l6m56iv3ysxgm2walhg4c9wp7q183jb328687i9zlp85csvjj";
  };

  patches = stdenv.lib.optional stdenv.isSunOS ./patch-ah.patch;

  # fixes: can't build x86_64-unknown-cygwin shared library unless -no-undefined is specified
  postPatch = optionalString stdenv.hostPlatform.isCygwin ''
    substituteInPlace tests/plugins/Makefile.in \
      --replace 'la_LDFLAGS =' 'la_LDFLAGS = $(WIN32_EXTRA_LDFLAGS)'
  '';

  outputs = [ "bin" "dev" "out" "man" "doc" ] ++ stdenv.lib.optional pythonSupport "py";

  buildInputs = [ libxml2.dev ] ++ stdenv.lib.optionals pythonSupport [ libxml2.py python2 ];

  propagatedBuildInputs = [ findXMLCatalogs ];

  configureFlags = [
    "--with-libxml-prefix=${libxml2.dev}"
    "--without-debug"
    "--without-mem-debug"
    "--without-debugger"
  ] ++ optional pythonSupport "--with-python=${python2}"
    ++ optional (!cryptoSupport) "--without-crypto";

  postFixup = ''
    moveToOutput bin/xslt-config "$dev"
    moveToOutput lib/xsltConf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '' + optionalString pythonSupport ''
    mkdir -p $py/nix-support
    echo ${libxml2.py} >> $py/nix-support/propagated-build-inputs
    moveToOutput lib/python2.7 "$py"
  '';

  passthru = {
    inherit pythonSupport;
  };

  meta = with stdenv.lib; {
    homepage = http://xmlsoft.org/XSLT/;
    description = "A C library and tools to do XSL transformations";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.eelco ];
  };
}
