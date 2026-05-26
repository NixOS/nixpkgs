{
  runCommand,
  replaceVars,
}:

sitePackages:

let
  hook = replaceVars ./setup-hook.sh {
    inherit sitePackages;
  };
in
runCommand "python-setup-hook.sh"
  {
    strictDeps = true;
  }
  ''
    cp ${hook} $out
  ''
