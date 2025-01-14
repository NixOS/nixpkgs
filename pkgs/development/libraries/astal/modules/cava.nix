{ buildAstalModule }:
buildAstalModule {
  name = "cava";
  meta.description = "Astal module for audio visualization using cava";
  meta.broken = true; # https://github.com/NixOS/nixpkgs/pull/368312
}
