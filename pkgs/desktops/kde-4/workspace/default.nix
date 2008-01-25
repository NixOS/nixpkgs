args: with args;

stdenv.mkDerivation {
  name = "kdebase-workspace-4.0.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdebase-workspace-4.0.0.tar.bz2;
    sha256 = "08sgp7jaqljdxwsgr5lyyfd6w734yv24zswps1mchmhj01vz1fcg";
  };

  propagatedBuildInputs = [kdelibs kdepimlibs stdenv.gcc.libc libusb
  libpthreadstubs];
  buildInputs = [cmake];
  patchPhase = "fixCmakeDbusCalls";
}
