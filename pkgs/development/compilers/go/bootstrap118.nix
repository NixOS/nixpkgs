{ callPackage }:
callPackage ./binary.nix {
  version = "1.18.10";
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    darwin-amd64 = "5614904f2b0b546b1493f294122fea7d67b2fbfc2efe84b1ab560fb678502e1f";
    darwin-arm64 = "718b32cb2c1d203ba2c5e6d2fc3cf96a6952b38e389d94ff6cdb099eb959dade";
    linux-386 = "9249551992c9518ec8ce6690d32206f12ed9122e360407f7e7ab9a6adc627a9b";
    linux-amd64 = "5e05400e4c79ef5394424c0eff5b9141cb782da25f64f79d54c98af0a37f8d49";
    linux-arm64 = "160497c583d4c7cbc1661230e68b758d01f741cf4bece67e48edc4fdd40ed92d";
    linux-armv6l = "e9f2f2361364c04a8f0d12228e4c5c2b870f4d1639ca92031c4013a95aa205be";
    linux-ppc64le = "761014290febf0e10dfeba44ec551792dad32270a11debee8ed4f30c5f3c760d";
    linux-s390x = "9755ab0460a04b535e513fac84db2e1ae6a197d66d3a097e14aed3b3114df85d";
  };
}
