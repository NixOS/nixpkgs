{stdenv, fetchurl, libtool}:

stdenv.mkDerivation {
  name = "chmlib-0.31";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://66.93.236.84/~jedwin/projects/chmlib/chmlib-0.31.tbz;
    md5 = "c6c9e1658f43715456e00a4893d496ed";
  };
  buildInputs = [libtool];
}
