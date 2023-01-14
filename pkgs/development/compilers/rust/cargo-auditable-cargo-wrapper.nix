{ lib, writeShellApplication, cargo, cargo-auditable }:

(writeShellApplication {
  name = "cargo";
  runtimeInputs = [ cargo cargo-auditable ];
  text = ''
    CARGO_AUDITABLE_IGNORE_UNSUPPORTED=1 cargo auditable "$@"
  '';
}) // {
  meta = cargo-auditable.meta // {
    mainProgram = "cargo";
  };
}
