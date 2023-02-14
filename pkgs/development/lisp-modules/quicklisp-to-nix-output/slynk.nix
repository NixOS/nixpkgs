/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "slynk";
  version = "sly-20220220-git";

  parasites = [ "slynk/arglists" "slynk/fancy-inspector" "slynk/indentation" "slynk/mrepl" "slynk/package-fu" "slynk/profiler" "slynk/retro" "slynk/stickers" "slynk/trace-dialog" ];

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/sly/2022-02-20/sly-20220220-git.tgz";
    sha256 = "0g24mmh7fpiinhzjay6ffm8mqpgl6f7hpw3rz2c0rx92xl3mvmhm";
  };

  packageName = "slynk";

  asdFilesToKeep = ["slynk.asd"];
  overrides = x: x;
}
/* (SYSTEM slynk DESCRIPTION System lacks description SHA256
    0g24mmh7fpiinhzjay6ffm8mqpgl6f7hpw3rz2c0rx92xl3mvmhm URL
    http://beta.quicklisp.org/archive/sly/2022-02-20/sly-20220220-git.tgz MD5
    87d214f13d8ed08a9b266555d3cac095 NAME slynk FILENAME slynk DEPS NIL
    DEPENDENCIES NIL VERSION sly-20220220-git SIBLINGS NIL PARASITES
    (slynk/arglists slynk/fancy-inspector slynk/indentation slynk/mrepl
     slynk/package-fu slynk/profiler slynk/retro slynk/stickers
     slynk/trace-dialog)) */
