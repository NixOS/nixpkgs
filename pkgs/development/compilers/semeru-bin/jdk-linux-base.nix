args:
import ../temurin-bin/jdk-linux-base.nix (
  {
    name-prefix = "semeru";
    brand-name = "IBM Semeru Runtime";
  }
  // args
)
