{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  callPackage,
}:

let
  # Simulator configurations from src/rules.py; bh_x32 needs -mcmodel=medium, which is x86_64 only
  configs = [
    "wh"
    "wh_x2"
    "wh_x8"
    "wh_x32"
    "bh"
    "bh_x2"
    "bh_x4"
  ]
  ++ lib.optional stdenv.hostPlatform.isx86_64 "bh_x32";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ttsim";
  version = "1.16.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "ttsim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L6FcCtnazmDFvE72hCtABz9I6it9BIvAKhBMfBaqza4=";
  };

  nativeBuildInputs = [ python3 ];

  # make.py runs each step with a minimal environment unless --inherit-env is given, which would
  # hide the cc wrapper's variables. Only release configurations are built; debug ones are for
  # simulator development, and the standalone riscv64 system simulator needs a guest image to be
  # useful, so it is left out. Upstream compiles x86_64 with -march=x86-64-v3, so x86_64 builds
  # need an AVX2 CPU (Haswell or newer).
  buildPhase = ''
    runHook preBuild
    python3 make.py --inherit-env -j $NIX_BUILD_CORES \
      ${lib.concatMapStringsSep " " (c: "src/_out/release_${c}/libttsim.so") configs}
    runHook postBuild
  '';

  # Libraries keep the upstream release asset names (libttsim_bh.so); tt-metal loads one through
  # TT_METAL_SIMULATOR
  installPhase = ''
    runHook preInstall
    ${lib.concatMapStringsSep "\n" (
      c: "install -Dm755 src/_out/release_${c}/libttsim.so $out/lib/libttsim_${c}.so"
    ) configs}
    runHook postInstall
  '';

  passthru.tests.pci-id = callPackage ./tests.nix { ttsim = finalAttrs.finalPackage; };

  meta = {
    description = "Full-system simulator of Tenstorrent Wormhole and Blackhole accelerators";
    homepage = "https://github.com/tenstorrent/ttsim";
    changelog = "https://github.com/tenstorrent/ttsim/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hz2 ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
