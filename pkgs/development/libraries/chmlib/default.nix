{stdenv, fetchurl, libtool}:

stdenv.mkDerivation {
  name = "chmlib-0.33";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/chmlib-0.33.tbz;
    md5 = "8bc84e94f1cea65005e5cb0ab40e2e86";
  };
  buildInputs = [libtool];
}
