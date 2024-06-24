# DO NOT port this expression to hadrian. It is not possible to build a GHC
# cross compiler with 9.4.* and hadrian.
import ./common-make-native-bignum.nix {
  version = "9.4.8";
  sha256 = "0bf407eb67fe3e3c24b0f4c8dea8cb63e07f63ca0f76cf2058565143507ab85e";
}
