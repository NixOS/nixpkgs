{ stdenv, fetchurl, fetchpatch, libxml2, findXMLCatalogs, python2, libgcrypt
, cryptoSupport ? false
, pythonSupport ? stdenv.buildPlatform == stdenv.hostPlatform
}:

assert pythonSupport -> python2 != null;
assert pythonSupport -> libxml2.pythonSupport;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "libxslt";
  version = "1.1.33";
  name = pname + "-" + version;

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "1j1q1swnsy8jgi9x7mclvkrqhfgn09886gdlr9wzk7a08i8n0dlf";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-11068.patch";
      url = "https://gitlab.gnome.org/GNOME/libxslt/commit/e03553605b45c88f0b4b2980adfbbb8f6fca2fd6.patch";
      sha256 = "0pkpb4837km15zgg6h57bncp66d5lwrlvkr73h0lanywq7zrwhj8";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libxslt/commit/c5eb6cf3aba0af048596106ed839b4ae17ecbcb1.patch";
      name = "CVE-2019-13117.patch";
      sha256 = "0ynfq8y5h623cypj1426iiz7796n3mqbjqa24ndvh2am6rl5lw15";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libxslt/commit/6ce8de69330783977dd14f6569419489875fb71b.patch";
      name = "CVE-2019-13118.patch";
      sha256 = "0bglz9m9sh2vi50qxcm06iqrazw3h45ycgxnp15iankq95z283iq";
    })
  ];

  outputs = [ "bin" "dev" "out" "man" "doc" ] ++ stdenv.lib.optional pythonSupport "py";

  buildInputs = [ libxml2.dev ]
    ++ stdenv.lib.optionals pythonSupport [ libxml2.py python2 ]
    ++ stdenv.lib.optionals cryptoSupport [ libgcrypt ];

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
