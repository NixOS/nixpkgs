/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-package-local-nicknames";
  version = "20200610-git";

  description = "Portability library for package-local nicknames";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-package-local-nicknames/2020-06-10/trivial-package-local-nicknames-20200610-git.tgz";
    sha256 = "1wabkcwz0v144rb2w3rvxlcj264indfnvlyigk1wds7nq0c8lwk5";
  };

  packageName = "trivial-package-local-nicknames";

  asdFilesToKeep = ["trivial-package-local-nicknames.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-package-local-nicknames DESCRIPTION
    Portability library for package-local nicknames SHA256
    1wabkcwz0v144rb2w3rvxlcj264indfnvlyigk1wds7nq0c8lwk5 URL
    http://beta.quicklisp.org/archive/trivial-package-local-nicknames/2020-06-10/trivial-package-local-nicknames-20200610-git.tgz
    MD5 b3620521d3400ad5910878139bc86fcc NAME trivial-package-local-nicknames
    FILENAME trivial-package-local-nicknames DEPS NIL DEPENDENCIES NIL VERSION
    20200610-git SIBLINGS NIL PARASITES NIL) */
