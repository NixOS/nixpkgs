# Zellij plugins

Zellij offers a Webassembly / WASI plugin system, allowing plugin developers to
develop plugins in many different languages. Currently, nixpkgs focuses only on
Rust plugins (the majority of them).

Most of the plugins were generated using `nix-init` on [awesome-zellij].
Excluded plugins from that list (should be packaged later anyway):

- [bar-theme-config](https://github.com/allisonhere/zellij-bar-theme-config): not a plugin, but a separate application
- [fzf-zellij](https://github.com/k-kuroguro/fzf-zellij): [closed source](https://github.com/k-kuroguro/fzf-zellij/issues/1)
- [gitpod-zellij](https://github.com/ona-samples/gitpod.zellij): not a plugin, but a separate application?
- [opencode-zellij-namer](https://github.com/24601/opencode-zellij-namer): written in TypeScript, not Rust
- [theme-configurator](https://rosmur.github.io/zellij-theme-configurator/): not a plugin, but a separate application
- [yazelix](https://github.com/luccahuguet/yazelix): written in Nushell
- [zeco](https://github.com/julianbuettner/zeco): not a plugin, but a separate application?
- [zellij-load](https://github.com/Christian-Prather/zellij-load): has daemon, so that needs to be packaged too
- [zellij-vscode-toolkit](https://github.com/atoolz/zellij-vscode-toolkit): not a plugin, but a VSCode plugin
- [zellix](https://github.com/EmeraldPandaTurtle/zellix): written in Nushell
- [zj-quit](https://github.com/cristiand391/zj-quit): archived
- [zj-status-bar](https://github.com/cristiand391/zj-status-bar): archived
- [zrw](https://github.com/ivoronin/zrw): written in Go

Contributions are welcome!

[awesome-zellij]: https://github.com/zellij-org/awesome-zellij/blob/95fce2c02a2dcca33e4972eed3eba64d516693c9/README.md

## Specifying runtime dependencies

Runtime dependencies are packages, that will be used by the plugin inside
a Zellij session. Those are specified in `passthru.runtimeDeps` attribute from
`pkgsBuildBuild` attrset.

Since we compile all plugins on WASI, everything that the plugin gets as
derivation arguments are also get compiled for WASI. However, `coreutils` is
not available on WASI and so is the vast majority of packages. This is why
runtime dependencies need to be specified from `pkgsBuildBuild` attrs set
(which points to the user's system).

```nix
# assume we build the plugin on a x86_64-linux machine
{
  lib,
  fetchFromGitHub,
  rustPlatform,

  # these will be compiled for WASI, not x86_64-linux!
  just,
  bacon,
  # but pkgsBuildBuild points to x86_64-linux
  pkgsBuildBuild,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jbz";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "nim65s";
    repo = "jbz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3n3Bv3YDb1+MYJTTAmMkIgGY7kX9IVUoDNV4c/n0Ydo=";
  };

  cargoHash = "sha256-U+P2LlhmXwaZy2a2eigrg545HTuV1T01jZfUOEUQ5+w=";

  # this is the only way how to specify dependencies
  passthru.runtimeDeps = with pkgsBuildBuild; [
    bacon
    just
  ];

  meta = {
    description = "Display your Just commands wrapped in Bacon";
    homepage = "https://github.com/nim65s/jbz";
    changelog = "https://github.com/nim65s/jbz/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PerchunPak ];
  };
})
```

If you are wondering why `pkgsBuildBuild` is named like that, refer to
[the docs on cross-compilation](https://nixos.org/manual/nixpkgs/unstable/#possible-dependency-types).
