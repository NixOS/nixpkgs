{
  lib,
  nix-update-script,
}:

nix-update-script {
  # Both packages update the same release and all of its sources.
  attrPath = "python3Packages.mlx-bin";
  extraArgs = [
    "--url=mirror://pypi/m/mlx/"
    "--override-filename=pkgs/development/python-modules/mlx/wheel-sources.nix"
    "--no-src"
  ]
  ++
    lib.concatMap
      (name: [
        "--subpackage"
        ''srcs."${name}"''
      ])
      (
        builtins.attrNames (import ./wheel-sources.nix).mlx
        ++ [
          "metal"
          "testSource"
        ]
      );
}
