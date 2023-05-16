{ lib
, stdenv
<<<<<<< HEAD
, cmake
, fetchFromGitHub
=======
, fetchFromGitHub
, pkg-config
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "capstone";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "aquynh";
    repo = "capstone";
    rev = version;
    sha256 = "sha256-XMwQ7UaPC8YYu4yxsE4bbR3leYPfBHu5iixSLz05r3g=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [
    cmake
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

<<<<<<< HEAD
  doCheck = true;
=======
  enableParallelBuilding = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "Advanced disassembly library";
    homepage    = "http://www.capstone-engine.org";
    license     = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thoughtpolice ris ];
    mainProgram = "cstool";
    platforms   = lib.platforms.unix;
  };
}
