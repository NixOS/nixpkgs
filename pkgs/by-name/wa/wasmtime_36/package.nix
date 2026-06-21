{
  nix-update-script,
  wasmtime,
}:

# NOTE: LTS Version EOL August 20 2027
(wasmtime.override { majorVersion = "36"; }).overrideAttrs (old: {
  __structuredAttrs = true;

  passthru = old.passthru // {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(36\\.\\d+\\.\\d+)$"
      ];
    };
  };
})
