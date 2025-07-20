{
  lib,
  buildPythonPackage,
  runCommand,
  fetchFromGitHub,
  rustPlatform,
  maturin,
}:
buildPythonPackage rec {
  pname = "pyluwen";
  version = "0.6.4";
  pyproject = true;

  src =
    runCommand "pyluwen-source"
      {
        src = fetchFromGitHub {
          owner = "tenstorrent";
          repo = "luwen";
          tag = "v${version}";
          hash = "sha256-yEIaDJ5MYyiI/O6I1sc1l1rHPTi1cK9k5AfT0SUIrUs=";
        };
      }
      ''
        runPhase unpackPhase
        cp -r ../$sourceRoot $out
        cp ${./Cargo.lock} $out/Cargo.lock
      '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-KDscT25Z1Hao+IQvUmp9yg/dcaP/FjlPLjEP5chB8DE=";
  };

  sourceRoot = "${src.name}/crates/${pname}";

  postUnpack = ''
    cp ${./Cargo.lock} $sourceRoot/Cargo.lock
    chmod -R u+w ${src.name}
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  build-system = [ maturin ];

  meta = {
    description = "Tenstorrent system interface library";
    homepage = "https://github.com/tenstorrent/luwen";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
