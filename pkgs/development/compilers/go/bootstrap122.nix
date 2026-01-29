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
    linux-loong64 = "ef1644676782354369210ed6cd839ff872de886c38f287d29ac69377928edec1";
  };
}
