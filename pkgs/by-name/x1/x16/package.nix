{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  callPackage,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x16-emulator";
  version = "49";
  # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "X16Community";
    repo = "x16-emulator";
    tag = "r${finalAttrs.version}";
    hash = "sha256-BGo2YCyaWcOkMkzyRBlg8A4rb6hZ19eZTQXkA5Njv/g=";
  };

  # fix build w/ glibc-2.44
  env.NIX_CFLAGS_COMPILE = "-Wno-error=discarded-qualifiers";

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
    run = (callPackage ./run.nix { }) {
      inherit (finalAttrs.finalPackage) emulator rom;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://cx16forum.com/";
    description = "Official emulator of CommanderX16 8-bit computer";
    changelog = "https://github.com/X16Community/x16-emulator/blob/${finalAttrs.src.rev}/RELEASES.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "x16emu";
    inherit (SDL2.meta) platforms;
    broken = stdenv.hostPlatform.isAarch64; # ofborg fails to compile it
  };
})
