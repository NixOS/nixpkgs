{stdenv, fetchurl, zlib ? null, zlibSupport ? true}:

assert zlibSupport -> zlib != null;

stdenv.mkDerivation {
  name = "python-2.3.4";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/Python-2.3.4.tar.bz2;
    md5 = "a2c089faa2726c142419c03472fc4063";
  };
  buildInputs = [
    (if zlibSupport then zlib else null)
  ];
  inherit zlibSupport;
}
