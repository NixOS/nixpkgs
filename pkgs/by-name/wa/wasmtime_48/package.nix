{
  nix-update-script,
  wasmtime,
}:

# NOTE: LTS Version EOL August 20 2028
(wasmtime.override { variant = "lts-48"; }).overrideAttrs (old: {
  passthru = old.passthru // {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(48\\.\\d+\\.\\d+)$"
      ];
    };
  };
})
