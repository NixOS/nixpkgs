{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  name    = "capstone-${version}";
  version = "4.0.1";

  src = fetchurl {
    url    = "https://github.com/aquynh/capstone/archive/${version}.tar.gz";
    sha256 = "1isxw2qwy1fi3m3w7igsr5klzczxc5cxndz0a78dfss6ps6ymfvr";
  };

  configurePhase = '' patchShebangs make.sh '';
  buildPhase = '' ./make.sh '';
  installPhase = '' env PREFIX=$out ./make.sh install '';
  
  nativeBuildInputs = [
    pkgconfig
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Advanced disassembly library";
    homepage    = "http://www.capstone-engine.org";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
