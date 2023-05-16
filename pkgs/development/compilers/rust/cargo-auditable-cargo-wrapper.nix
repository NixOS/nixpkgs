<<<<<<< HEAD
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

=======
{ lib, runCommand, makeBinaryWrapper, cargo, cargo-auditable }:

runCommand "auditable-${cargo.name}" {
  nativeBuildInputs = [ makeBinaryWrapper ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = cargo-auditable.meta // {
    mainProgram = "cargo";
  };
} ''
  mkdir -p $out/bin
  makeWrapper ${cargo}/bin/cargo $out/bin/cargo \
    --set CARGO_AUDITABLE_IGNORE_UNSUPPORTED 1 \
<<<<<<< HEAD
    --prefix PATH : ${lib.makeBinPath [ cargo cargo-auditable ]} \
    --add-flags auditable
=======
    --prefix PATH : ${lib.makeBinPath [ cargo cargo-auditable ]}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
''
