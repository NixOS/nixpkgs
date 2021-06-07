{ lib, stdenv, fetchurl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "capstone";
  version = "4.0.2";

  src = fetchurl {
    url    = "https://github.com/aquynh/capstone/archive/${version}.tar.gz";
    sha256 = "0sjjbqps48az4map0kmai7j7dak3gy0xcq0sgx8fg09g0acdg0bw";
  };

  # replace faulty macos detection
  postPatch = lib.optionalString stdenv.isDarwin ''
    sed -i 's/^IS_APPLE := .*$/IS_APPLE := 1/' Makefile
  '';

  configurePhase = "patchShebangs make.sh ";
  buildPhase = "PREFIX=$out ./make.sh";

  doCheck = true;
  checkPhase = ''
    # first remove fuzzing steps from check target
    substituteInPlace Makefile --replace "fuzztest fuzzallcorp" ""
    make check
  '';

  installPhase = (lib.optionalString stdenv.isDarwin "HOMEBREW_CAPSTONE=1 ")
    + "PREFIX=$out ./make.sh install";

  nativeBuildInputs = [
    pkg-config
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Advanced disassembly library";
    homepage    = "http://www.capstone-engine.org";
    license     = lib.licenses.bsd3;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ thoughtpolice ris ];
  };
}
