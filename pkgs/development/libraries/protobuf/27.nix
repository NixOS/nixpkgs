{ callPackage, ... } @ args:

callPackage ./generic.nix ({
  version = "27.4";
  hash = "sha256-PejX1RlEw8ASU7vWMdpQ8WaPJrxURK01GXBx+pvwV4I=";
} // args)
