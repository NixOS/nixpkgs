/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "numpy-file-format";
  version = "20210124-git";

  parasites = [ "numpy-file-format/tests" ];

  description = "Read and write Numpy .npy and .npz files.";

  deps = [ args."ieee-floats" args."trivial-features" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/numpy-file-format/2021-01-24/numpy-file-format-20210124-git.tgz";
    sha256 = "17iwihpf28f5q4hgz93vixrrq35ya4x5fmz3mdqhgpqkdhpf012h";
  };

  packageName = "numpy-file-format";

  asdFilesToKeep = ["numpy-file-format.asd"];
  overrides = x: x;
}
/* (SYSTEM numpy-file-format DESCRIPTION
    Read and write Numpy .npy and .npz files. SHA256
    17iwihpf28f5q4hgz93vixrrq35ya4x5fmz3mdqhgpqkdhpf012h URL
    http://beta.quicklisp.org/archive/numpy-file-format/2021-01-24/numpy-file-format-20210124-git.tgz
    MD5 0d81ce1e67ed1323787eb0f3cd698113 NAME numpy-file-format FILENAME
    numpy-file-format DEPS
    ((NAME ieee-floats FILENAME ieee-floats)
     (NAME trivial-features FILENAME trivial-features)
     (NAME uiop FILENAME uiop))
    DEPENDENCIES (ieee-floats trivial-features uiop) VERSION 20210124-git
    SIBLINGS NIL PARASITES (numpy-file-format/tests)) */
