{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  name    = "capstone-${version}";
  version = "3.0.5";

  src = fetchurl {
    url    = "https://github.com/aquynh/capstone/archive/${version}.tar.gz";
    sha256 = "1wbd1g3r32ni6zd9vwrq3kn7fdp9y8qwn9zllrrbk8n5wyaxcgci";
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
