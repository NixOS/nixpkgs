args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-file-size'';
  version = ''20180131-git'';

  parasites = [ "trivial-file-size/tests" ];

  description = ''Stat a file's size.'';

  deps = [ args."fiveam" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-file-size/2018-01-31/trivial-file-size-20180131-git.tgz'';
    sha256 = ''1dhbj764rxw8ndr2l06g5lszzvxis8fjbp71i3l2y9zmdm0k5zrd'';
  };

  packageName = "trivial-file-size";

  asdFilesToKeep = ["trivial-file-size.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-file-size DESCRIPTION Stat a file's size. SHA256
    1dhbj764rxw8ndr2l06g5lszzvxis8fjbp71i3l2y9zmdm0k5zrd URL
    http://beta.quicklisp.org/archive/trivial-file-size/2018-01-31/trivial-file-size-20180131-git.tgz
    MD5 ac921679334dd8bd12f927f0bd806f4b NAME trivial-file-size FILENAME
    trivial-file-size DEPS
    ((NAME fiveam FILENAME fiveam) (NAME uiop FILENAME uiop)) DEPENDENCIES
    (fiveam uiop) VERSION 20180131-git SIBLINGS NIL PARASITES
    (trivial-file-size/tests)) */
