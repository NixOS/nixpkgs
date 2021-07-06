/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "enchant";
  version = "cl-20190521-git";

  description = "Programming interface for Enchant spell-checker library";

  deps = [ args."alexandria" args."babel" args."cffi" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-enchant/2019-05-21/cl-enchant-20190521-git.tgz";
    sha256 = "16ag48fr74m536an8fak5z0lfjdb265gv1ajai1lqg0vq2l5mr14";
  };

  packageName = "enchant";

  asdFilesToKeep = ["enchant.asd"];
  overrides = x: x;
}
/* (SYSTEM enchant DESCRIPTION
    Programming interface for Enchant spell-checker library SHA256
    16ag48fr74m536an8fak5z0lfjdb265gv1ajai1lqg0vq2l5mr14 URL
    http://beta.quicklisp.org/archive/cl-enchant/2019-05-21/cl-enchant-20190521-git.tgz
    MD5 2a868c280fd5a74f9c298c384567e31b NAME enchant FILENAME enchant DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi trivial-features) VERSION
    cl-20190521-git SIBLINGS (enchant-autoload) PARASITES NIL) */
