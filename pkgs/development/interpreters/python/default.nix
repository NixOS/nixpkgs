{stdenv, fetchurl, zlib ? null, zlibSupport ? true}:

assert zlibSupport -> zlib != null;

stdenv.mkDerivation {
  name = "python-2.4.3";
  src = fetchurl {
    url = http://www.python.org/ftp/python/2.4.3/Python-2.4.3.tar.bz2;
    md5 = "141c683447d5e76be1d2bd4829574f02";
  };
  buildInputs = [
    (if zlibSupport then zlib else null)
  ];
  inherit zlibSupport;
  configureFlags = "--enable-shared";
}
