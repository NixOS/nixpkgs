{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  fuse3,
  opencl-clhpp,
  ocl-icd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vramfs";
  version = "unstable-2025-11-02";

  src = fetchFromGitHub {
    owner = "Overv";
    repo = "vramfs";
    rev = "cc2605e11a08ccd5651a816d28ec4d11f18836c9";
    hash = "sha256-BllW4kP4hYtqhhcdjz/WzunyvmaLuSFl1ia2Zad4NUM=";
  };

  strictDeps = true;

  __structuredAttrs = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fuse3
    opencl-clhpp
    ocl-icd
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/vramfs $out/bin/vramfs
    runHook postInstall
  '';

  meta = {
    description = "VRAM based file system for Linux";
    homepage = "https://github.com/Overv/vramfs";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "vramfs";
    maintainers = with lib.maintainers; [ pascal ];
  };
})
