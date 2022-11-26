{
  pkgs ? import ../../../../.. {},
  skip ? [ ]
}:

# To test all packages:
#
#     nix-build
#
# To test only one package, e.g. alexandria:
#
#     nix-build -A alexandria
#
# To test all packages that aren’t marked as explicitly failing (iow: this is
# how you should really use this, in CI, as a regression test):
#
#     nix-build -E 'import ./. { skip = (import ./. {}).failingTests; }'

pkgs.lib.pipe pkgs.lispPackagesLite [
  (pkgs.lib.attrsets.filterAttrs (n: v:
    (pkgs.lib.attrsets.isDerivation v) && !(builtins.elem n skip)
  ))
  (builtins.mapAttrs (k: v: v.enableCheck))
] // {
  # These checks are currently failing. This array can be passed directly as an
  # argument to this file’s skip param, and all resulting tests should
  # pass. Let’s try to get this to zero!
  failingTests = [
    "fare-quasiquote"
    "lack"
    "lack-request"
    "lift"
    "log4cl"
    "trivial-backtrace"
    "try"
  ];
}
