args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-indent'';
  version = ''20180831-git'';

  description = ''A very simple library to allow indentation hints for SWANK.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-indent/2018-08-31/trivial-indent-20180831-git.tgz'';
    sha256 = ''017ydjyp9v1bqfhg6yq73q7lf2ds3g7s8i9ng9n7iv2k9ffxm65m'';
  };

  packageName = "trivial-indent";

  asdFilesToKeep = ["trivial-indent.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-indent DESCRIPTION
    A very simple library to allow indentation hints for SWANK. SHA256
    017ydjyp9v1bqfhg6yq73q7lf2ds3g7s8i9ng9n7iv2k9ffxm65m URL
    http://beta.quicklisp.org/archive/trivial-indent/2018-08-31/trivial-indent-20180831-git.tgz
    MD5 0cc411500f5aa677cd771d45f4cd21b8 NAME trivial-indent FILENAME
    trivial-indent DEPS NIL DEPENDENCIES NIL VERSION 20180831-git SIBLINGS NIL
    PARASITES NIL) */
