{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "STLport-5.2.0";

  src = fetchurl {
    url = mirror://sourceforge/stlport/STLport-5.2.0.tar.bz2;
    md5 = "448d74859407912c0087adcf51bf109a";
  };
}
