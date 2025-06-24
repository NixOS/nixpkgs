{
  lib,
  runCommand,
  cargo,
  makeBinaryWrapper,
  cargoSubcommands,
}:

lib.makeOverridable (
  subcommands: f:
  runCommand "cargo-wrapper"
    {
      inherit (cargo) version meta;
      buildInputs = [
        makeBinaryWrapper
      ];
    }
    ''
      mkdir -p "$out/bin"
      makeWrapper "${lib.getExe cargo}" "$out/bin/cargo" \
        --prefix PATH : ${lib.makeBinPath (f subcommands)}
    ''
) cargoSubcommands
