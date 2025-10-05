{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_14,
  nix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zon2nix";
  version = "0.1.3-unstable-2025-03-20";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "zon2nix";
    rev = "2360e358c2107860dadd340f88b25d260b538188";
    hash = "sha256-89hYzrzQokQ+HUOd3g4epP9jdajaIoaMG81SrCNCqqU=";
  };

  nativeBuildInputs = [
    zig_0_14.hook
  ];

  zigBuildFlags = [
    "-Dnix=${lib.getExe nix}"
  ];

  zigCheckFlags = [
    "-Dnix=${lib.getExe nix}"
  ];

  meta = {
    description = "Convert the dependencies in `build.zig.zon` to a Nix expression";
    mainProgram = "zon2nix";
    homepage = "https://github.com/nix-community/zon2nix";
    changelog = "https://github.com/nix-community/zon2nix/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      figsoda
      RossComputerGuy
    ];
    inherit (zig_0_14.meta) platforms;
  };
})
