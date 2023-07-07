/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "enchant";
  version = "cl-20211209-git";

  description = "Programming interface for Enchant spell-checker library";

  deps = [ args."alexandria" args."babel" args."cffi" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-enchant/2021-12-09/cl-enchant-20211209-git.tgz";
    sha256 = "1j9qliyxfjfz4bbc6snysccnmmk2d2y8kb613rna239dh5g6c03c";
  };

  packageName = "enchant";

  asdFilesToKeep = ["enchant.asd"];
  overrides = x: x;
}
/* (SYSTEM enchant DESCRIPTION
    Programming interface for Enchant spell-checker library SHA256
    1j9qliyxfjfz4bbc6snysccnmmk2d2y8kb613rna239dh5g6c03c URL
    http://beta.quicklisp.org/archive/cl-enchant/2021-12-09/cl-enchant-20211209-git.tgz
    MD5 c12162b3a7c383815ff77c96aca0c11f NAME enchant FILENAME enchant DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi trivial-features) VERSION
    cl-20211209-git SIBLINGS (enchant-autoload) PARASITES NIL) */
