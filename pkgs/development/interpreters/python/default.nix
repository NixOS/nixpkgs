{stdenv, fetchurl, zlib ? null, zlibSupport ? true}:

assert zlibSupport -> zlib != null;

stdenv.mkDerivation {
  name = "python-2.3.4";
  src = fetchurl {
    url = http://www.python.org/ftp/python/2.3.4/Python-2.3.4.tar.bz2;
    md5 = "a2c089faa2726c142419c03472fc4063";
  };
  buildInputs = [
    (if zlibSupport then zlib else null)
  ];
  inherit zlibSupport;
}
