args: with args;

stdenv.mkDerivation {
  name = "kdebase-runtime-4.0rc2";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.97/src/kdebase-runtime-3.97.0.tar.bz2;
    sha256 = "16xang1sjj0h8339cfqf6l4qqswyv42sq9w9a3axmckklmfnx6b1";
  };

  propagatedBuildInputs = [kdepimlibs libusb xineLib];
  patchPhase = "fixCmakeDbusCalls";
}

