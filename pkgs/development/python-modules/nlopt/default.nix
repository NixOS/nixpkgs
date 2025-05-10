{
  toPythonModule,
  pkgs,
}:
toPythonModule (pkgs.nlopt.override { withPython = true; })
