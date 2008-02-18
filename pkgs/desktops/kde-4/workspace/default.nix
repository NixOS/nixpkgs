args: with args;

stdenv.mkDerivation rec {
  name = "kdebase-workspace-" + version;
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/${name}.tar.bz2";
    sha256 = "0mnww5j7v381xf763gcfqp41klng40hb3283blnxcw2p5fp13b3k";
  };

  propagatedBuildInputs = [kde4.pimlibs kde4.support.qimageblitz stdenv.gcc.libc
    libusb libpthreadstubs libxklavier];
  buildInputs = [cmake];
  patchPhase = "fixCmakeDbusCalls";
}
