{ kde, kdelibs }:

kde {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0mrd3w7rhsj0v92c8rh9zjxyifq7wyvwszksf2gyn53dzd06blk8";

  buildInputs = [ kdelibs ];

  meta = {
    description = "KDE Base artwork";
    license = "GPL";
  };
}
