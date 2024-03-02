{callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.10.8";
  sha256 = "0jgdl4fxw0hwy768rl3lhdc0czz7ak7czf3dg10j21pdpfpfvpi6";
})
