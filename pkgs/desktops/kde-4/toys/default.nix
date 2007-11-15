args: with args;

stdenv.mkDerivation {
  name = "kdetoys-4.0beta4";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.95/src/kdetoys-3.95.0.tar.bz2;
    sha256 = "0qg9ns640v21sa837pg5basnw8clnkyxap2lm7s69ainsg69662v";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace];
}
