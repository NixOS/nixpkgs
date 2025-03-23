{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_11,
  nix,
}:

stdenv.mkDerivation rec {
  pname = "zon2nix";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "zon2nix";
    rev = "v${version}";
    hash = "sha256-pS0D+wdebtpNaGpDee9aBwEKTDvNU56VXer9uzULXcM=";
  };

  nativeBuildInputs = [
    zig_0_11.hook
  ];

  zigBuildFlags = [
    "-Dnix=${lib.getExe nix}"
  ];

  zigCheckFlags = [
    "-Dnix=${lib.getExe nix}"
  ];

  meta = with lib; {
    description = "Convert the dependencies in `build.zig.zon` to a Nix expression";
    mainProgram = "zon2nix";
    homepage = "https://github.com/nix-community/zon2nix";
    changelog = "https://github.com/nix-community/zon2nix/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
    inherit (zig_0_11.meta) platforms;
  };
}
