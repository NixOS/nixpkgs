{
  lib,
  stdenv,
  callPackage,
  fetchFromCodeberg,
  zig_0_16,
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ztags";
  version = "1.0.1-unstable-2026-04-23";

  src = fetchFromCodeberg {
    owner = "gpanders";
    repo = "ztags";
    rev = "49d45d0db73c6e5705853bfdb25a471d19538993";
    hash = "sha256-RawMttAMlRj2ofXmtgeCl/g8XxyUZjXg22heHYRpJy8=";
  };

  deps = callPackage ./deps.nix { };

  nativeBuildInputs = [ zig ];

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  meta = {
    description = "Generate tags files for Zig projects";
    homepage = "https://codeberg.org/gpanders/ztags";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ztags";
    inherit (zig.meta) platforms;
  };
})
