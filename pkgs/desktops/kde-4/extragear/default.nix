args: with args;

stdenv.mkDerivation {
  name = "extragear-plasma-4.0.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/extragear/extragear-plasma-4.0.0.tar.bz2;
    sha256 = "19gmvqkal11gg67gfmdivxbhwvggm2i6ad642984d97yicms7s9k";
  };

  buildInputs = [ kdeworkspace cmake ];
  patchPhase = ''
  sed -e 's@<Plasma@<KDE/Plasma@' -i ../applets/*/*.h
  echo ${kdeworkspace}
  fixCmakeDbusCalls ${kdeworkspace}
  '';
}
