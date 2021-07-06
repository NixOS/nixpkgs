/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "file-attributes";
  version = "20210411-git";

  description = "Access to file attributes (uid, gid, atime, mtime, mod)";

  deps = [ args."alexandria" args."babel" args."cffi" args."documentation-utils" args."trivial-features" args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/file-attributes/2021-04-11/file-attributes-20210411-git.tgz";
    sha256 = "0zsqimyzfivr08d6pdg6xxw6cj7q9pjh2wi9c460nh85z7a51yc9";
  };

  packageName = "file-attributes";

  asdFilesToKeep = ["file-attributes.asd"];
  overrides = x: x;
}
/* (SYSTEM file-attributes DESCRIPTION
    Access to file attributes (uid, gid, atime, mtime, mod) SHA256
    0zsqimyzfivr08d6pdg6xxw6cj7q9pjh2wi9c460nh85z7a51yc9 URL
    http://beta.quicklisp.org/archive/file-attributes/2021-04-11/file-attributes-20210411-git.tgz
    MD5 75e0f0e2c280c97fe496545e7105fa01 NAME file-attributes FILENAME
    file-attributes DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES
    (alexandria babel cffi documentation-utils trivial-features trivial-indent)
    VERSION 20210411-git SIBLINGS NIL PARASITES NIL) */
