/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-package-local-nicknames";
  version = "20220220-git";

  description = "Portability library for package-local nicknames";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-package-local-nicknames/2022-02-20/trivial-package-local-nicknames-20220220-git.tgz";
    sha256 = "1is3yj7jas4blr3a92dh18yn59ay5jsl715cwy435y61cqm0c756";
  };

  packageName = "trivial-package-local-nicknames";

  asdFilesToKeep = ["trivial-package-local-nicknames.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-package-local-nicknames DESCRIPTION
    Portability library for package-local nicknames SHA256
    1is3yj7jas4blr3a92dh18yn59ay5jsl715cwy435y61cqm0c756 URL
    http://beta.quicklisp.org/archive/trivial-package-local-nicknames/2022-02-20/trivial-package-local-nicknames-20220220-git.tgz
    MD5 d6959b6dd52f354bafa5fa6bcb7b42a1 NAME trivial-package-local-nicknames
    FILENAME trivial-package-local-nicknames DEPS NIL DEPENDENCIES NIL VERSION
    20220220-git SIBLINGS NIL PARASITES NIL) */
