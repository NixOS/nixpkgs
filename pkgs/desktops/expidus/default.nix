{ callPackage, flutterPackages }:
{
  calculator = callPackage ./calculator {
    flutter = flutterPackages.v3_35;
  };

  file-manager = callPackage ./file-manager {
    flutter = flutterPackages.v3_35;
  };
}
