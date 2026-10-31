{
  lib,
  nix-update-script,
}:

let
  wheelSources = import ./wheel-sources.nix;
  subpackages =
    map (name: ''srcs.mlx."${name}"'') (builtins.attrNames wheelSources.mlx)
    ++ map (name: ''srcs.mlx-metal."${name}"'') (builtins.attrNames wheelSources.mlx-metal)
    ++ [ "srcs.testSource" ];
in
nix-update-script {
  # Both packages update the same release and all of its sources.
  attrPath = "python3Packages.mlx-bin";
  extraArgs = [
    "--url=mirror://pypi/m/mlx/"
    "--override-filename=pkgs/development/python-modules/mlx/wheel-sources.nix"
    "--no-src"
  ]
  ++ lib.concatMap (path: [
    "--subpackage"
    path
  ]) subpackages;
}
