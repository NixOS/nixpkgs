{ lib, stdenv, fetchurl
, pkg-config
, libxml2, findXMLCatalogs, gettext, python, libgcrypt
, cryptoSupport ? false
, pythonSupport ? stdenv.buildPlatform == stdenv.hostPlatform
}:

stdenv.mkDerivation rec {
  pname = "libxslt";
  version = "1.1.34";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${pname}-${version}.tar.gz";
    sha256 = "0zrzz6kjdyavspzik6fbkpvfpbd25r2qg6py5nnjaabrsr3bvccq";
  };

  outputs = [ "bin" "dev" "out" "man" "doc" ] ++ lib.optional pythonSupport "py";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ libxml2.dev ]
    ++ lib.optional stdenv.isDarwin gettext
    ++ lib.optionals pythonSupport [ libxml2.py python ]
    ++ lib.optionals cryptoSupport [ libgcrypt ];

  propagatedBuildInputs = [ findXMLCatalogs ];

  configureFlags = [
    "--without-debug"
    "--without-mem-debug"
    "--without-debugger"
  ] ++ lib.optional pythonSupport "--with-python=${python}"
    ++ lib.optional (!cryptoSupport) "--without-crypto";

  postFixup = ''
    moveToOutput bin/xslt-config "$dev"
    moveToOutput lib/xsltConf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '' + lib.optionalString pythonSupport ''
    mkdir -p $py/nix-support
    echo ${libxml2.py} >> $py/nix-support/propagated-build-inputs
    moveToOutput ${python.libPrefix} "$py"
  '';

  passthru = {
    inherit pythonSupport;
  };

  meta = with lib; {
    homepage = "http://xmlsoft.org/XSLT/";
    description = "A C library and tools to do XSL transformations";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.eelco ];
    broken = !(pythonSupport -> libxml2.pythonSupport); # see #73102 for why this is not an assert
  };
}
