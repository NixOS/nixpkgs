# buildFontPackage

Packaging and updating fonts in nixpkgs is relatively easy. With `buildFontPackage` you only need the `src` in form of a directory (not a single file) and package metadata.

See ../agave/default.nix and ../3270font/default.nix for example.

You can run the test with `nix-build ~/code/nixpkgs -A 3270font.tests`.

It will create previews for all font files. This way we know, that they are usable.

```
[user@nixos:~]$ nix-build ~/code/nixpkgs -A _3270font.tests
these derivations will be built:
  /nix/store/lhrkq4551w0hf9q7gyh9nfm8ik8vd3zv-3270font-2.0.4.drv
  /nix/store/v1lny7vra0ymr6652v544h00cicglj2i-3270font-test.drv
building '/nix/store/lhrkq4551w0hf9q7gyh9nfm8ik8vd3zv-3270font-2.0.4.drv'...
unpacking sources
unpacking source archive /nix/store/gma0xqzfhwlmvm0xh58k751crs3pgiw3-source
source root is source
patching sources
installing
building '/nix/store/v1lny7vra0ymr6652v544h00cicglj2i-3270font-test.drv'...
/nix/store/rnmqdjpv89ik2k86chz0lc8r6ppgn20n-3270font-test

[user@nixos:~]$ tree /nix/store/rnmqdjpv89ik2k86chz0lc8r6ppgn20n-3270font-test
/nix/store/rnmqdjpv89ik2k86chz0lc8r6ppgn20n-3270font-test
├── 3270Condensed-Regular.otf.png
├── 3270Condensed-Regular.ttf.png
├── 3270Condensed-Regular.woff.png
├── 3270-Regular.otf.png
├── 3270-Regular.ttf.png
├── 3270-Regular.woff.png
├── 3270SemiCondensed-Regular.otf.png
├── 3270SemiCondensed-Regular.ttf.png
└── 3270SemiCondensed-Regular.woff.png

0 directories, 9 files
```
