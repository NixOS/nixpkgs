args: with args;

stdenv.mkDerivation {
  name = "kdebase-runtime-4.0.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.0/src/kdebase-runtime-4.0.0.tar.bz2;
    sha256 = "0svsn9gzg3ka77j7z71fy502a09w9gp9jd2q2y1w07ahpdil5p7h";
  };

  propagatedBuildInputs = [kdepimlibs libusb xineLib];
  patchPhase = "fixCmakeDbusCalls";
}

