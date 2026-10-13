{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig_0_17,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zigscient";
  version = "0.17.0";

  strictDeps = true;
  __structuredAttrs = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
    "-Doptimize=ReleaseFast"
  ];
  preBuild = ''
    export ZIG_DEBUG_CMD=1;
    export ZIG_LIB_DIR=./lib;
  '';

  deps = callPackage ./deps_0_17.nix { };
  nativeBuildInputs = [ zig_0_17 ];

  src = fetchFromGitHub {
    owner = "llogick";
    repo = "zigscient";
    tag = finalAttrs.version;
    hash = "sha256-tWgUZm9kW8B/tCIx5g2N4mVRiqKxLy+YuxBv0iSvLds=";
  };

  meta = {
    description = "Zig Language Server - A drop-in alternative to ZLS";
    mainProgram = "zigscient";
    homepage = "https://github.com/llogick/zigscient";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      alorans
    ];
    platforms = lib.platforms.unix;
  };
})
