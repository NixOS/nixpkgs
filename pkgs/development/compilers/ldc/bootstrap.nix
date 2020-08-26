{ callPackage }:
callPackage ./binary.nix {
  version = "1.19.0";
  hashes = {
    # Get these from `nix-prefetch-url https://github.com/ldc-developers/ldc/releases/download/v1.19.0/ldc2-1.19.0-osx-x86_64.tar.xz` etc..
    osx-x86_64 = "1bp3xkh9zp64dzq8isanib1gacb3nfbl70qv15qygwk1zan6zgy7";
    linux-x86_64 = "146grr2lwarfk13wgkpyb77xb6b3as1is2rf4s2hipqjmc8biy1h";
    linux-aarch64  = "1fv6jshfvi15m7masgxq1hgp216qjd5amizrqdf26vhrq3a08li3";
  };
}
