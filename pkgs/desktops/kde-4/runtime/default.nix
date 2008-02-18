args: with args;

stdenv.mkDerivation rec {
  name = "kdebase-runtime-" + version;
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/${name}.tar.bz2";
    sha256 = "05f5z705483509i1z6z0kgj0226smhp4cpj733h29bvwa76yi3b4";
  };

  propagatedBuildInputs = [kde4.pimlibs libusb xineLib samba];
  buildInputs = [cmake];
  patchPhase = "fixCmakeDbusCalls";
}

