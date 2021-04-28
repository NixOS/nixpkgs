/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "ironclad";
  version = "v0.54";

  parasites = [ "ironclad/tests" ];

  description = "A cryptographic toolkit written in pure Common Lisp";

  deps = [ args."alexandria" args."bordeaux-threads" args."rt" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/ironclad/2021-01-24/ironclad-v0.54.tgz";
    sha256 = "01mpsnjx8cgn3wx2n0dkv8v83z93da9zrxncn58ghbpyq3z1i4w2";
  };

  packageName = "ironclad";

  asdFilesToKeep = ["ironclad.asd"];
  overrides = x: x;
}
/* (SYSTEM ironclad DESCRIPTION
    A cryptographic toolkit written in pure Common Lisp SHA256
    01mpsnjx8cgn3wx2n0dkv8v83z93da9zrxncn58ghbpyq3z1i4w2 URL
    http://beta.quicklisp.org/archive/ironclad/2021-01-24/ironclad-v0.54.tgz
    MD5 f99610509e4603aac66d9aa03ede2770 NAME ironclad FILENAME ironclad DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads) (NAME rt FILENAME rt))
    DEPENDENCIES (alexandria bordeaux-threads rt) VERSION v0.54 SIBLINGS
    (ironclad-text) PARASITES (ironclad/tests)) */
