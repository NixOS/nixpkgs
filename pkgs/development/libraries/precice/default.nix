{ lib, stdenv, fetchFromGitHub, cmake, gcc, boost, eigen, libxml2, openmpi, python2, python2Packages }:

stdenv.mkDerivation rec {
  pname = "precice";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "precice";
    repo = pname;
    rev = "v${version}";
    sha256 = "00631zw6cpm67j35cwad04nwgfcvlxa8p660fwz30pgj2hzdx3d2";
  };

  preConfigure = ''
    cmakeFlags="-DBUILD_SHARED_LIBS=ON -DPETSC=off"
  '';

  nativeBuildInputs = [ cmake gcc ];
  buildInputs = [ boost eigen libxml2 openmpi python2 python2Packages.numpy ];
  installPhase = ''
    mkdir -p $out/lib
    cp libprecice.so libprecice.so.1.6.1 $out/lib/
  '';

  meta = {
    description = "preCICE stands for Precise Code Interaction Coupling Environment";
    license = with lib.licenses; [ gpl3 ];
    homepage = "https://www.precice.org/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
}

