{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  callPackage,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vigil";
  version = "0-unstable-2026-01-04";

  src = fetchFromGitHub {
    owner = "chase-lambert";
    repo = "vigil";
    rev = "7e8501ec3c06b42a46baa3d2171aad18404e9daf";
    hash = "sha256-oxzofOHswP9OvENidEwOzBhl+hS3dTzAkZysJC0+vF0=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  strictDeps = true;

  zigBuildFlags = finalAttrs.zigCheckFlags ++ [
    "-Doptimize=ReleaseSafe"
  ];

  zigCheckFlags = [
    "--system"
    "${finalAttrs.deps}"
    "-Dcpu=baseline"
  ];

  dontSetZigDefaultFlags = true;

  nativeBuildInputs = [
    zig
  ];

  meta = {
    description = "Clean, fast build watcher for Zig";
    homepage = "https://github.com/chase-lambert/vigil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "vigil";
    inherit (zig.meta) platforms;
  };
})
