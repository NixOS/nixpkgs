{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "directfb-1.1.0";
  src = fetchurl {
    url = http://www.directfb.org/downloads/Core/DirectFB-1.1.0.tar.gz;
    sha256 = "0fpjlgsyblvcjvqk8m3va2xsyx512mf26kwfsxarj1vql9b75s0f";
  };
  buildInputs = [perl];
}
