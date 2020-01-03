{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "capstone";
  version = "4.0.1";

  src = fetchurl {
    url    = "https://github.com/aquynh/capstone/archive/${version}.tar.gz";
    sha256 = "1isxw2qwy1fi3m3w7igsr5klzczxc5cxndz0a78dfss6ps6ymfvr";
  };

  # replace faulty macos detection
  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's/^IS_APPLE := .*$/IS_APPLE := 1/' Makefile
  '';

  configurePhase = '' patchShebangs make.sh '';
  buildPhase = "PREFIX=$out ./make.sh";

  doCheck = true;
  checkPhase = ''
    # first remove fuzzing steps from check target
    substituteInPlace Makefile --replace "fuzztest fuzzallcorp" ""
    make check
  '';

  installPhase = (stdenv.lib.optionalString stdenv.isDarwin "HOMEBREW_CAPSTONE=1 ")
    + "PREFIX=$out ./make.sh install";
  
  nativeBuildInputs = [
    pkgconfig
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Advanced disassembly library";
    homepage    = "http://www.capstone-engine.org";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ris ];
  };
}
