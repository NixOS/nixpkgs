# DO NOT port this expression to hadrian. It is not possible to build a GHC
# cross compiler with 9.4.* and hadrian.
import ./common-make-native-bignum.nix {
  version = "9.4.5";
  sha256 = "6256cf9caf6d6dc7b611dcfbb247df2d528e85aa39d22a698e870e5a590e8601";
}
