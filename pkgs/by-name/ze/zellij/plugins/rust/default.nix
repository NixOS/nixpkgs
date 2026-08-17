{ pkgsCross, lib }:
let
  root = ./.;
  pkgs' = pkgsCross.wasi32;

  call = name: override (pkgs'.callPackage (root + "/${name}") { });
  override =
    pkg:
    pkg.overrideAttrs (old: {
      # these hacks are needed until https://github.com/NixOS/nixpkgs/pull/463720#pullrequestreview-3841639011 is resolved
      nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ pkgs'.lld ];
      env = old.env or { } // {
        RUSTFLAGS = old.env.RUSTFLAGS or "" + " -C linker=wasm-ld";
      };

      meta = old.meta or { } // {
        platforms = old.meta.platforms or lib.platforms.linux;
      };
    });
in
lib.pipe root [
  builtins.readDir
  (lib.filterAttrs (name: _: name != "default.nix" && name != "README.md"))
  (lib.mapAttrs' (name: _: lib.nameValuePair (lib.removeSuffix ".nix" name) (call name)))
]
