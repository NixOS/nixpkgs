{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_16,
  nix,
}:
let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zon2nix";
  version = "0.1.3-unstable-2026-04-13";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "zon2nix";
    rev = "d1e1762ce1e5d4df3b65a0d45421b6fb7b99cf92";
    hash = "sha256-LzmPWG0cEhQS3+NDg/5KRgsUJHygllTK9lvDJJI/o+U=";
  };

  nativeBuildInputs = [
    zig
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
      RossComputerGuy
    ];
    inherit (zig.meta) platforms;
  };
})
