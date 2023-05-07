/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-mysql";
  version = "20200610-git";

  description = "Common Lisp MySQL library bindings";

  deps = [ args."alexandria" args."babel" args."cffi" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-mysql/2020-06-10/cl-mysql-20200610-git.tgz";
    sha256 = "0fzyqzz01zn9fy8v766lib3dghg9yq5wawa0hcmxslms7knzxz7w";
  };

  packageName = "cl-mysql";

  asdFilesToKeep = ["cl-mysql.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-mysql DESCRIPTION Common Lisp MySQL library bindings SHA256
    0fzyqzz01zn9fy8v766lib3dghg9yq5wawa0hcmxslms7knzxz7w URL
    http://beta.quicklisp.org/archive/cl-mysql/2020-06-10/cl-mysql-20200610-git.tgz
    MD5 05d5ed6b48edbafd258e189d7868822e NAME cl-mysql FILENAME cl-mysql DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi trivial-features) VERSION 20200610-git
    SIBLINGS (cl-mysql-test) PARASITES NIL) */
