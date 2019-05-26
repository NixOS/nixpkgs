{callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.12.1";
  sha256 = "0nln45662kg799ykvqx5m9z9qcsmadmgg6r5najryls7x16in2d9";
})
