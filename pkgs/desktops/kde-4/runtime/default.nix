args: with args;

stdenv.mkDerivation rec {
  name = "kdebase-runtime-4.0.0";
  
  src = fetchurl {
    url = "mirror://kde/stable/4.0/src/${name}.tar.bz2";
    sha256 = "0svsn9gzg3ka77j7z71fy502a09w9gp9jd2q2y1w07ahpdil5p7h";
  };

  propagatedBuildInputs = [kdepimlibs libusb xineLib samba];
  buildInputs = [cmake];
  phononPatch = ./phonon.patch;
  patchPhase = "fixCmakeDbusCalls; patch -p0 < ${phononPatch}";
}

