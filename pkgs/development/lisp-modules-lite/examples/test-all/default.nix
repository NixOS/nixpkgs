{
  pkgs ? import ../../../../.. {}
  , lispPackagesLite ? pkgs.lispPackagesLite
  , skip ? [
    "arnesi"
    "fare-quasiquote"
    # I’m confused as to why this one is failing
    "gettext"
    "lack"
    "lack-request"
    "lift"
    "log4cl"
    "lparallel"
    "trivial-backtrace"
    "try"
    "typo"
  ]
}:

pkgs.lib.pipe lispPackagesLite [
  (pkgs.lib.attrsets.filterAttrs (n: v:
    (pkgs.lib.attrsets.isDerivation v) && !(builtins.elem n skip)
  ))
  (builtins.mapAttrs (k: v: v.enableCheck))
]
