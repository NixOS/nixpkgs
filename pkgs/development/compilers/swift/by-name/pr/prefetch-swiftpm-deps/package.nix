{
  coreutils,
  jq,
  nix,
  nix-prefetch-git,
  writeShellApplication,
}:

writeShellApplication {
  name = "prefetch-swiftpm-deps";
  runtimeInputs = [
    coreutils
    jq
    nix
    nix-prefetch-git
  ];
  text = builtins.readFile ./prefetch-swiftpm-deps.sh;
}
