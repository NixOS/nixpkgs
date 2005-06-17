{stdenv, fetchurl, zlib ? null, zlibSupport ? true}:

assert zlibSupport -> zlib != null;

stdenv.mkDerivation {
  name = "python-2.4.1";
  src = fetchurl {
    url = http://www.python.org/ftp/python/2.4.1/Python-2.4.1.tar.bz2;
    md5 = "de3e9a8836fab6df7c7ce545331afeb3";
  };
  buildInputs = [
    (if zlibSupport then zlib else null)
  ];
  inherit zlibSupport;
}
