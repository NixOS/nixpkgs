{ callPackage, flutterPackages }:
{
  calculator = callPackage ./calculator {
    flutter = flutterPackages.v3_19;
  };

  file-manager = callPackage ./file-manager {
    flutter = flutterPackages.v3_19;
  };
}
