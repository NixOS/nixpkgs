{ callPackage }:
callPackage ./binary.nix {
  version = "1.25.0";
  hashes = {
    # Get these from `nix-prefetch-url https://github.com/ldc-developers/ldc/releases/download/v1.19.0/ldc2-1.19.0-osx-x86_64.tar.xz` etc..
    osx-x86_64 = "1xaqxf1lz8kdb0n5iycfpxpvabf1zy0akg14kg554sm85xnsf8pa";
    linux-x86_64 = "1shzdq564jg3ga1hwrvpx30lpszc6pqndqndr5mqmc352znkiy5i";
    linux-aarch64  = "04i4xxwhq02d98r3qrrnv5dbd4xr4d7ph3zv94z2m58z3vgphdjh";
    osx-arm64  = "0b0cpgzn23clggx0cvdaja29q7w7ihkmjbnf1md03h9h5nzp9z1v";
  };
}
