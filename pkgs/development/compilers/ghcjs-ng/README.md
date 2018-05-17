New build system for GHCJS 8.2
---

`ghcjs-8.2` reworked the build system, and now comes with its own
small package set of dependencies. This involves autogenerating
several sources and cabal files, based on a GHC
checkout. `callCabal2nix` is off limits, since we don't like "import
from derivation" in nixpkgs. So there is a derivation that builds the
nix expression that should be checked in whenever GHCJS is updated.

Updating
---

```
$ nix-prefetch-git https://github.com/ghcjs/ghcjs --rev refs/heads/ghc-8.2 \
  | jq '{ url, rev, fetchSubmodules, sha256 }' \
  > 8.2/git.json
$ cat $(nix-build ../../../.. -A haskell.compiler.ghcjs82.genStage0 --no-out-link) > 8.2/stage0.nix
```

