{stdenv, fetchurl, libtool}:

stdenv.mkDerivation {
  name = "chmlib-0.33";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://66.93.236.84/~jedwin/projects/chmlib/chmlib-0.33.tbz;
    md5 = "8bc84e94f1cea65005e5cb0ab40e2e86";
  };
  buildInputs = [libtool];
}
