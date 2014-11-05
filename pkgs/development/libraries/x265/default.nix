{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.4";
  rev = "5e604833c5aa605d0b6efbe5234492b5e7d8ac61";
  sha256 = "1aqksqi1qmjpva5cal6j7h0hzk298wk3nhqv73wnyqdchq2sa8v5";
})