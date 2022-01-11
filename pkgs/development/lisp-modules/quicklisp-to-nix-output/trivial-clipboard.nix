/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-clipboard";
  version = "20210228-git";

  description = "trivial-clipboard let access system clipboard.";

  deps = [ args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-clipboard/2021-02-28/trivial-clipboard-20210228-git.tgz";
    sha256 = "1fmxkz97qrjkc320w849r1411f7j2ghf3g9xh5lczcapgjwq8f0l";
  };

  packageName = "trivial-clipboard";

  asdFilesToKeep = ["trivial-clipboard.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-clipboard DESCRIPTION
    trivial-clipboard let access system clipboard. SHA256
    1fmxkz97qrjkc320w849r1411f7j2ghf3g9xh5lczcapgjwq8f0l URL
    http://beta.quicklisp.org/archive/trivial-clipboard/2021-02-28/trivial-clipboard-20210228-git.tgz
    MD5 f147ff33934a3796d89597cea8dbe462 NAME trivial-clipboard FILENAME
    trivial-clipboard DEPS ((NAME uiop FILENAME uiop)) DEPENDENCIES (uiop)
    VERSION 20210228-git SIBLINGS (trivial-clipboard-test) PARASITES NIL) */
