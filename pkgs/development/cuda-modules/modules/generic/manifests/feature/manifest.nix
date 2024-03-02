{lib, config, ...}:
let
  inherit (lib) options trivial types;
  Release = import ./release.nix {inherit lib config;};
in
options.mkOption {
  description = "A feature manifest is an attribute set which includes a mapping from package name to release";
  example = trivial.importJSON ../../../../cuda/manifests/feature_11.5.2.json;
  type = types.attrsOf Release.type;
}
