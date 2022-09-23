{ runCommand }:

sitePackages:

let
  hook = ./setup-hook.sh;
in runCommand "python-setup-hook.sh" {
  strictDeps = true;
  inherit sitePackages;
} ''
  cp ${hook} hook.sh
  substituteAllInPlace hook.sh
  mv hook.sh $out
''
