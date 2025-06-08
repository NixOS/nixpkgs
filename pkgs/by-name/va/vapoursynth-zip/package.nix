{
  callPackage,
  fetchFromGitHub,
  lib,
  stdenv,
  zig,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-zip";
  version = "7";

  src = fetchFromGitHub {
    owner = "dnjulek";
    repo = "vapoursynth-zip";
    tag = "R${finalAttrs.version}";
    hash = "sha256-/bHD+t5upQ+So1k+5/IbNTfeugMqcnlDlaH/H9nXgR8=";
  };

  buildInputs = [
    zig.hook
  ];

  zigBuildFlags = [ "--release=fast" ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    mv $out/lib/libvszip.so $out/lib/vapoursynth
  '';

  meta = {
    description = "VapourSynth Zig Image Process";
    homepage = "https://github.com/dnjulek/vapoursynth-zip";
    changelog = "https://github.com/dnjulek/vapoursynth-zip/releases";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
