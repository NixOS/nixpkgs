{ lib, runCommand, makeBinaryWrapper, cargo, cargo-auditable }:

runCommand "auditable-${cargo.name}" {
  nativeBuildInputs = [ makeBinaryWrapper ];
  meta = cargo-auditable.meta // {
    mainProgram = "cargo";
  };
} ''
  mkdir -p $out/bin
  makeWrapper ${cargo}/bin/cargo $out/bin/cargo \
    --set CARGO_AUDITABLE_IGNORE_UNSUPPORTED 1 \
    --prefix PATH : ${lib.makeBinPath [ cargo cargo-auditable ]}
''
