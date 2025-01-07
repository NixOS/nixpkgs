# DO NOT port this expression to hadrian. It is not possible to build a GHC
# cross compiler with 9.4.* and hadrian.
import ./common-make-native-bignum.nix {
  version = "9.4.6";
  sha256 = "1b705cf52692f9d4d6707cdf8e761590f5f56ec8ea6a65e36610db392d3d24b9";
}
