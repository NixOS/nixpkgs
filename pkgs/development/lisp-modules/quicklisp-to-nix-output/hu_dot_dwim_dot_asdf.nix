/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_asdf";
  version = "stable-git";

  description = "Various ASDF extensions such as attached test and documentation system, explicit development support, etc.";

  deps = [ args."asdf" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.asdf/2021-12-30/hu.dwim.asdf-stable-git.tgz";
    sha256 = "0na57b7qdy2i05s2ycq1gffxn98havsw9ia1nsr99fw7jngg1skv";
  };

  packageName = "hu.dwim.asdf";

  asdFilesToKeep = ["hu.dwim.asdf.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.asdf DESCRIPTION
    Various ASDF extensions such as attached test and documentation system, explicit development support, etc.
    SHA256 0na57b7qdy2i05s2ycq1gffxn98havsw9ia1nsr99fw7jngg1skv URL
    http://beta.quicklisp.org/archive/hu.dwim.asdf/2021-12-30/hu.dwim.asdf-stable-git.tgz
    MD5 20251cb11ed1d151dc7194a010e196a9 NAME hu.dwim.asdf FILENAME
    hu_dot_dwim_dot_asdf DEPS
    ((NAME asdf FILENAME asdf) (NAME uiop FILENAME uiop)) DEPENDENCIES
    (asdf uiop) VERSION stable-git SIBLINGS (hu.dwim.asdf.documentation)
    PARASITES NIL) */
