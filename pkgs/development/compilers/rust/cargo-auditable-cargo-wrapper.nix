{ lib, runCommand, makeBinaryWrapper, rust-audit-info, cargo, cargo-auditable }:

if cargo-auditable.meta.broken then
  cargo
else
runCommand "auditable-${cargo.name}" {
  nativeBuildInputs = [ makeBinaryWrapper ];

  passthru.tests = runCommand "rust-audit-info-test" {
    nativeBuildInputs = [ rust-audit-info ];
  } ''
    rust-audit-info ${lib.getBin rust-audit-info}/bin/rust-audit-info > $out
  '';

  meta = cargo-auditable.meta // {
    mainProgram = "cargo";
  };
} ''
  mkdir -p $out/bin
  makeWrapper ${cargo}/bin/cargo $out/bin/cargo \
    --set CARGO_AUDITABLE_IGNORE_UNSUPPORTED 1 \
    --prefix PATH : ${lib.makeBinPath [ cargo cargo-auditable ]} \
    --add-flags auditable
''
