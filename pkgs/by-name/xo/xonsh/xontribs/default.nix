{
  pythonPackages,
}:
let
  inherit (pythonPackages) callPackage;
in
{
  xonsh-direnv = callPackage ./xonsh-direnv { };
}
