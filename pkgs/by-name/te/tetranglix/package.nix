{
  lib,
  stdenv,
  nasm,
  fetchFromGitHub,
  makeWrapper,
  qemu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tetranglix";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "nanochess";
    repo = "tetranglix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eQ5whKYcTcFumbeqR54pnrWSweEXGswE+2NQ7Y+IR7w=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    nasm
  ];

  buildInputs = [ qemu ];

  installPhase = ''
    runHook preInstall

    install -Dm644 tetranglix.img \
      $out/share/tetranglix/tetranglix.img

    makeWrapper ${qemu}/bin/qemu-system-i386 \
      $out/bin/tetranglix \
      --add-flags "-drive format=raw,file=$out/share/tetranglix/tetranglix.img,if=floppy,readonly=on"

    runHook postInstall
  '';

  meta = {
    description = "Bootable 512-byte Tetris clone";
    homepage = "https://github.com/nanochess/tetranglix";
    mainProgram = "tetranglix";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
