{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.13";
  branch = "2.8";
  sha256 = "0y3712ivmpr5dw1nsk1bqpd4b7ldzd69ak4vwbl4q02ab35ri6yz";
})
