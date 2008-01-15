args: with args;

stdenv.mkDerivation {
  name = "kdenetwork-4.0.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.0/src/kdenetwork-4.0.0.tar.bz2;
    sha256 = "04vigr2z0md64khjdriwslsyaf6mpqxd2iwsnr82g53x4kh0i061";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace sqlite libidn];
}
