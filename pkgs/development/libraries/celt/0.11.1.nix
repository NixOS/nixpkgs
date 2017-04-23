{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec{
  version = "0.11.1";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/celt/celt-${version}.tar.gz";
    sha256 = "1gsc3pxydyzzra8w0r6hrrsalm76lrq4lw6bd283qa4bpagmghh1";
  };
})
