args: with args;

stdenv.mkDerivation {
  name = "extragear-plasma-4.0rc2";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.97/src/extragear-plasma-3.97.0.tar.bz2;
    sha256 = "1nzfy34ig66gfpgv6kbcmcap13axcy7kvj43srbd0ic6a0giv283";
  };

  buildInputs = [ kdeworkspace kdebase ];
  patchPhase = "
  sed -e 's@<Plasma@<KDE/Plasma@' -i ../applets/*/*.h";
}
