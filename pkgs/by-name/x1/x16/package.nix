{ lib
, stdenv
, fetchFromGitHub
, SDL2
, callPackage
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x16-emulator";
  version = "48";

  src = fetchFromGitHub {
    owner = "X16Community";
    repo = "x16-emulator";
    rev = "r${finalAttrs.version}";
    hash = "sha256-E4TosRoORCWLotOIXROP9oqwqo1IRSa6X13GnmuxE9A=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '/bin/echo' 'echo'
  '';

  dontConfigure = true;

  buildInputs = [
    SDL2
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 -t $out/bin/ x16emu
    install -Dm 444 -t $out/share/doc/x16-emulator/ README.md

    runHook postInstall
  '';

  passthru = {
    # upstream project recommends emulator and rom to be synchronized; passing
    # through the version is useful to ensure this
    inherit (finalAttrs) version;
    emulator = finalAttrs.finalPackage;
    rom = callPackage ./rom.nix { };
    run = (callPackage ./run.nix { }){
      inherit (finalAttrs.finalPackage) emulator rom;
    };
  };

  meta = {
    homepage = "https://cx16forum.com/";
    description = "Official emulator of CommanderX16 8-bit computer";
    changelog = "https://github.com/X16Community/x16-emulator/blob/r${finalAttrs.version}/RELEASES.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    mainProgram = "x16emu";
    inherit (SDL2.meta) platforms;
    broken = stdenv.hostPlatform.isAarch64; # ofborg fails to compile it
  };
})
