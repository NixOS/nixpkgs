{ callPackage, zlib }:
callPackage ./common.nix rec {
  version = "0.4.0";
  url = "https://www.prevanders.net/libdwarf-${version}.tar.xz";
  sha512 = "30e5c6c1fc95aa28a014007a45199160e1d9ba870b196d6f98e6dd21a349e9bb31bba1bd6817f8ef9a89303bed0562182a7d46fcbb36aedded76c2f1e0052e1e";
  buildInputs = [ zlib ];
}
