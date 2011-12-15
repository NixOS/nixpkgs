{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "libical-0.47";
  src = fetchurl {
    url = "mirror://sourceforge/freeassociation/${name}.tar.gz";
    sha256 = "1218vaaks9lvx31mrc8212kyngw2k68xm0914vrd77ixn55vnk5g";
  };
  buildNativeInputs = [ perl ];
}
