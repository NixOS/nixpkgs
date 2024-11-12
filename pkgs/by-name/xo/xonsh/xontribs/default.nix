{
  pythonPackages,
}:
let
  inherit (pythonPackages) callPackage;
in
{
  xonsh-direnv = callPackage ./xonsh-direnv { };
  xontrib-abbrevs = callPackage ./xontrib-abbrevs { };
  xontrib-bashisms = callPackage ./xontrib-bashisms { };
}
