# DO NOT port this expression to hadrian. It is not possible to build a GHC
# cross compiler with 9.4.* and hadrian.
import ./common-make-native-bignum.nix {
  version = "9.4.7";
  sha256 = "06775a52b4d13ac09edc6dabc299fd11e59d8886bbcae450af367baee2684c8f";
}
