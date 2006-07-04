{stdenv, fetchurl, zlib ? null, zlibSupport ? true}:

assert zlibSupport -> zlib != null;

stdenv.mkDerivation {
  name = "python-2.5b1";
  src = fetchurl {
    url = http://www.python.org/ftp/python/2.5/Python-2.5b1.tgz;
    md5 = "957c8d24d2ba8d4ba028c7f348ac5c86";
  };
  buildInputs = [
    (if zlibSupport then zlib else null)
  ];
  inherit zlibSupport;
  configureFlags = "--enable-shared";
}
