{ callPackage, apacheHttpd  }:
callPackage ./generic.nix {
  phpVersion = "5.6.9";
  sha = "1fdwk8g509gxd5ad3y1s3j49hfkjdg8mgmzn9ki3pflbgdxvilqr";
  apacheHttpd = apacheHttpd;
}
