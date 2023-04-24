{ lib, buildPackages, writeScriptBin, cargo, cargo-auditable }:

(writeScriptBin "cargo" ''
  #!${buildPackages.runtimeShell} -e
  export PATH="${lib.makeBinPath [ cargo cargo-auditable ]}:$PATH"
  CARGO_AUDITABLE_IGNORE_UNSUPPORTED=1 exec cargo auditable "$@"
'') // {
  meta = cargo-auditable.meta // {
    mainProgram = "cargo";
  };
}
