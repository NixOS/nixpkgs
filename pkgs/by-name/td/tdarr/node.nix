{ mkTdarr, ccextractor }:

mkTdarr {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-pT0zHp5KGDQp+c0vXsw0lhghrBCH/IAqc0t1tM5zWBM=";
    linux_arm64 = "sha256-k3doWqSm18KYvksvcCw/fxF3AGfz2KYPzCas1ffLd70=";
    darwin_arm64 = "sha256-bfwKlZsiQB60BSgKx1AbcE8XJ7lsO+AyQe/a109VU1c=";
  };

  includeInPath = [ ccextractor ];
}
