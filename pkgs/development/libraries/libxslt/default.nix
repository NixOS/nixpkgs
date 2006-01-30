{stdenv, fetchurl, libxml2}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "libxslt-1.1.14";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libxslt-1.1.15.tar.gz;
    md5 = "238de9eda71b570ff7b78aaf65308fc6";
  };
  buildInputs = [libxml2];
}
