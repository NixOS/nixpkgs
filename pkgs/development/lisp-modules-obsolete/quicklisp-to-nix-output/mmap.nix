/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "mmap";
  version = "20201220-git";

  description = "Portable mmap (file memory mapping) utility library.";

  deps = [ args."alexandria" args."babel" args."cffi" args."documentation-utils" args."trivial-features" args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/mmap/2020-12-20/mmap-20201220-git.tgz";
    sha256 = "147xw351xh90k3yvc1fn7k418afmgngd56i8a6d7p41fzs54g6ij";
  };

  packageName = "mmap";

  asdFilesToKeep = ["mmap.asd"];
  overrides = x: x;
}
/* (SYSTEM mmap DESCRIPTION
    Portable mmap (file memory mapping) utility library. SHA256
    147xw351xh90k3yvc1fn7k418afmgngd56i8a6d7p41fzs54g6ij URL
    http://beta.quicklisp.org/archive/mmap/2020-12-20/mmap-20201220-git.tgz MD5
    e2dbeb48b59735bd2ed54ea7f9cdfe0f NAME mmap FILENAME mmap DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES
    (alexandria babel cffi documentation-utils trivial-features trivial-indent)
    VERSION 20201220-git SIBLINGS (mmap-test) PARASITES NIL) */
