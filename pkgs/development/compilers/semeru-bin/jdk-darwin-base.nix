args:
import ../temurin-bin/jdk-darwin-base.nix (
  {
    name-prefix = "semeru";
    brand-name = "IBM Semeru Runtime";
  }
  // args
)
