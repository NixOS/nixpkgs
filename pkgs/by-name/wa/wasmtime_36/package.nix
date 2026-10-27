{
  nix-update-script,
  wasmtime,
}:

# NOTE: LTS Version EOL August 20 2027
(wasmtime.override { variant = "lts-36"; }).overrideAttrs (old: {
  passthru = old.passthru // {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(36\\.\\d+\\.\\d+)$"
      ];
    };
  };
})
