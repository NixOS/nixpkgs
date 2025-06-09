{ callPackage, flutterPackages }:
{
  calculator = callPackage ./calculator {
    flutter = flutterPackages.v3_24;
  };

  file-manager = callPackage ./file-manager {
    flutter = flutterPackages.v3_24;
  };
}
