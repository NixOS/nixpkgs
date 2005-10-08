{stdenv, fetchurl, pkgconfig, libX11, libXext, recordext, libXtrans}:

stdenv.mkDerivation {
  name = "libXtst-6.2.2-cvs";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/libXtst-6.2.2.tar.bz2;
    md5 = "6ee58bdcb151f1eccc761262f737e7d3";
  };
  buildInputs = [pkgconfig libX11 libXext recordext libXtrans];
}
