# Tree-sitter Grammars

Use [grammar-sources.nix](grammar-sources.nix) to define tree-sitter grammar sources.

Tree-sitter grammars follow a common form for compatibility with the [`tree-sitter` CLI](https://tree-sitter.github.io/tree-sitter/cli/index.html).
This uniformity enables consistent packaging through shared tooling.

## Adding a Grammar

To declare a new package, map the language name to a set of metadata required for the build.
At a minimum, this must include the `version` and `src`.

You may use a shorthand [flakeref](https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix3-flake#url-like-syntax) style `url` and `hash` for concise declarations.
If the hash is not yet known, use a [fake hash placeholder](https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-fetchers-updating-source-hashes).

```nix
{
  latex = {
    version = "0.42.0";
    url = "github:vandelay-industries/tree-sitter-latex";
    hash = "";
  };
}
```

This will expand to an element in `pkgs.tree-sitter.grammars` at build time:

```nix
{
  tree-sitter-latex = {
    language = "latex";
    version = "0.42.0";
    src = fetchFromGitHub {
      owner = "vandelay-industries";
      repo = "tree-sitter-latex";
      ref = "v0.42.0";
      hash = "";
    };
  };
}
```

Each entry is passed to [buildGrammar](build-grammar.nix), which in turn populates `pkgs.tree-sitter-grammars`.

Attempt to build the new grammar: `nix-build -A tree-sitter-grammars.tree-sitter-latex`.
This will fail due to the invalid hash.
Review the downloaded source, then update the source definition with the printed source `hash`.

## Pinning Grammar Sources

To pin to a specific ref, append this to the source `url` to override the default version tag.

```nix
{
  latex = {
    version = "0.42.0";
    url = "github:vandelay-industries/tree-sitter-latex/ccfd77db0ed799b6c22c214fe9d2937f47bc8b34";
    hash = "";
  };
}
```

This may be either a commit hash or tag.

## Supported sources

The `url` field supports the following prefixes:

- `github:` → uses `fetchFromGitHub`
- `gitlab:` → uses `fetchFromGitLab`
- `sourcehut:` → uses `fetchFromSourcehut`

To use [other fetchers](https://nixos.org/manual/nixpkgs/unstable/#chap-pkgs-fetchers), specify the `src` attribute directly:

```nix
{
  foolang = {
    version = "0.42.0";
    src = fetchtorrent {
      config = {
        peer-limit-global = 100;
      };
      url = "magnet:?xt=urn:btih:dd8255ecdc7ca55fb0bbf81323d87062db1f6d1c";
      hash = "";
    };
  };
}
```

## Modifying Build Behaviour

Additional attributes in the grammar definition are forwarded to `buildGrammar`, and then to `mkDerivation`.
This includes build-related flags and metadata.

```nix
{
  foolang = {
    version = "1729.0.0";
    url = "sourcehut:~example/tree-sitter-foolang";
    hash = "";
    generate = true;
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        kimburgess
      ];
    };
  };
}
```

## Overriding the Grammar Set

Use `pkgs.tree-sitter-grammars.overrideScope` when adding a grammar or replacing a grammar that another package should consume.
`pkgs.tree-sitter-grammars` is the scoped package set used for grammar overrides and scoped helpers such as `derivations`, `allGrammars`, and `withPlugins`.

```nix
let
  grammars = pkgs.tree-sitter-grammars.overrideScope (
    final: prev: {
      tree-sitter-foolang = pkgs.tree-sitter.buildGrammar {
        language = "foolang";
        version = "0.42.0";
        src = pkgs.fetchFromGitHub {
          owner = "example";
          repo = "tree-sitter-foolang";
          rev = "v0.42.0";
          hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };
      };

      tree-sitter-rust = prev.tree-sitter-rust.overrideAttrs (_: {
        version = "custom";
        src = pkgs.fetchFromGitHub {
          owner = "example";
          repo = "tree-sitter-rust";
          rev = "custom";
          hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };
      });
    }
  );
in
grammars.withPlugins (p: [
  p.tree-sitter-foolang
  p.tree-sitter-rust
])
```

The scoped `withPlugins` helper receives derivations from the same overridden scope, so added or replaced grammars are visible.

The set also carries package-set helpers (`callPackage`, `newScope`, `overrideScope`, …) alongside the grammars, so do not iterate it directly.
Use one of its grammar-only views instead; each reflects any `overrideScope`:

- `pkgs.tree-sitter-grammars.derivations` — attrset of every grammar derivation, including grammars marked broken.
- `pkgs.tree-sitter-grammars.allGrammars` — list of the non-broken grammar derivations.
- `pkgs.tree-sitter-grammars.withPlugins` — build a grammar link farm.

```nix
builtins.attrValues pkgs.tree-sitter-grammars.derivations
```

`pkgs.tree-sitter.builtGrammars` remains the plain attribute set generated directly from [grammar-sources.nix](grammar-sources.nix); use it when you specifically want the stock grammars without any scope overrides.

## Building WebAssembly Parsers

`buildGrammar` builds a native `$out/parser`.
To build grammars as WebAssembly instead, use the `wasi32` cross package set, which installs `$out/parser.wasm`:

```nix
pkgsCross.wasi32.tree-sitter.builtGrammars.tree-sitter-nix
```

The Wasm build compiles `parser.c` and a C `scanner.c`.
Grammars with C++ external scanners are rejected; use the native `buildGrammar` for those.

## Updating

All grammar sources have a default update script defined.
To manually trigger an update of a specific grammar definition:

```shell
nix-shell maintainers/scripts/update.nix --argstr package tree-sitter-grammars.tree-sitter-${name}
```

Or, to update all grammars:

```shell
nix-shell maintainers/scripts/update.nix --argstr path tree-sitter-grammars --arg keep-going true
```
