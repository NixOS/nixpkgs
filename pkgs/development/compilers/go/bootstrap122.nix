{ callPackage }:
callPackage ./binary.nix {
  version = "1.22.12";
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    darwin-amd64 = "e7bbe07e96f0bd3df04225090fe1e7852ed33af37c43a23e16edbbb3b90a5b7c";
    darwin-arm64 = "416c35218edb9d20990b5d8fc87be655d8b39926f15524ea35c66ee70273050d";
    freebsd-386 = "85b00f8646e84be6ce51c753d22b68a5f4d5bbfc6a82c8ca9e7489c0c5a619d8";
    freebsd-amd64 = "a8c77e76859db3e6f3322cbe11deea5faf779e374f45df7554d2cb484ffa492a";
    freebsd-arm64 = "f56d3b2d26acd9e720f8be503d92bb7bb5d921462ff7c92463d0fa550507ed93";
    freebsd-armv6l = "dac691ce62ac6b9c78f45a0058d7656abedbe5665b3d49910cbd6ba12e20c2fb";
    freebsd-riscv64 = "d147c0c8faaffed65240f3b4fe5e44e573928827b9292fb873c9712d567fa986";
    linux-386 = "40d4c297bc2e964e9c96fe79bb323dce79b77b8b103fc7cc52e0a87c7849890f";
    linux-amd64 = "4fa4f869b0f7fc6bb1eb2660e74657fbf04cdd290b5aef905585c86051b34d43";
    linux-arm64 = "fd017e647ec28525e86ae8203236e0653242722a7436929b1f775744e26278e7";
    linux-armv6l = "bcd678461bb74cda217fb5aa3cc914b2021be6d828f0c6fb4e3a36c3d7312acb";
    linux-loong64 = "ef1644676782354369210ed6cd839ff872de886c38f287d29ac69377928edec1";
    linux-mips = "993c685dad0a59f9f15f76a2eb9146f741ef36d808f38985bc6748b38000746d";
    linux-mips64 = "d8aa3dea17e0175d6a57dfdf9b3b29a911ebe8c5ddbefd808eab61a842c00229";
    linux-mips64le = "2d473895f9c1dc8c86d51eb13f8ca49b7eea46010759fd71efed3eecacf5335b";
    linux-mipsle = "d4ba5f6215643a1d64dc159869663f71dd339598e99678e97e1c5300bb46d46d";
    linux-ppc64 = "ab0b6dc2aa1096f256224398d4a34eac5257289146cdc2f3a62b9fc17709a3c5";
    linux-ppc64le = "9573d30003b0796717a99d9e2e96c48fddd4fc0f29d840f212c503b03d7de112";
    linux-riscv64 = "f03a084aabc812fdc15b29acd5e1ee18e13b3c80be22aec43990119afcaf4947";
    linux-s390x = "e1b20935cc790fdc4c48c0e3e6dd11be57ac09e4eb302ba2cdf146276468b346";
  };
}
