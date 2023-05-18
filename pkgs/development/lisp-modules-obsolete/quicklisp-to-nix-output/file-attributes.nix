/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "file-attributes";
  version = "20210807-git";

  description = "Access to file attributes (uid, gid, atime, mtime, mod)";

  deps = [ args."alexandria" args."babel" args."cffi" args."documentation-utils" args."trivial-features" args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/file-attributes/2021-08-07/file-attributes-20210807-git.tgz";
    sha256 = "0f2kr886jn83hlsk6a548cd0vdq4f1dsxscnslni0nhlxsbi1gsg";
  };

  packageName = "file-attributes";

  asdFilesToKeep = ["file-attributes.asd"];
  overrides = x: x;
}
/* (SYSTEM file-attributes DESCRIPTION
    Access to file attributes (uid, gid, atime, mtime, mod) SHA256
    0f2kr886jn83hlsk6a548cd0vdq4f1dsxscnslni0nhlxsbi1gsg URL
    http://beta.quicklisp.org/archive/file-attributes/2021-08-07/file-attributes-20210807-git.tgz
    MD5 ba0c3667061d97674f5b1666bcbc8506 NAME file-attributes FILENAME
    file-attributes DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES
    (alexandria babel cffi documentation-utils trivial-features trivial-indent)
    VERSION 20210807-git SIBLINGS NIL PARASITES NIL) */
