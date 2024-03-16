{ callPackage }:
{
  calculator = callPackage ./calculator {};
  file-manager = callPackage ./file-manager {};
}
