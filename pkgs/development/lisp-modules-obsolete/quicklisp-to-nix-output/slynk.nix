/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "slynk";
  version = "sly-20210411-git";

  parasites = [ "slynk/arglists" "slynk/fancy-inspector" "slynk/indentation" "slynk/mrepl" "slynk/package-fu" "slynk/profiler" "slynk/retro" "slynk/stickers" "slynk/trace-dialog" ];

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/sly/2021-04-11/sly-20210411-git.tgz";
    sha256 = "1a96aapsz3fhnnnb8njn8v2ddrh6kwisppd90cc7v8knh043xgks";
  };

  packageName = "slynk";

  asdFilesToKeep = ["slynk.asd"];
  overrides = x: x;
}
/* (SYSTEM slynk DESCRIPTION System lacks description SHA256
    1a96aapsz3fhnnnb8njn8v2ddrh6kwisppd90cc7v8knh043xgks URL
    http://beta.quicklisp.org/archive/sly/2021-04-11/sly-20210411-git.tgz MD5
    7f0ff6b8a07d23599c77cd33c6d59ea6 NAME slynk FILENAME slynk DEPS NIL
    DEPENDENCIES NIL VERSION sly-20210411-git SIBLINGS NIL PARASITES
    (slynk/arglists slynk/fancy-inspector slynk/indentation slynk/mrepl
     slynk/package-fu slynk/profiler slynk/retro slynk/stickers
     slynk/trace-dialog)) */
