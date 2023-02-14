/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-json";
  version = "20220220-git";

  parasites = [ "cl-json.test" ];

  description = "JSON in Lisp. JSON (JavaScript Object Notation) is a lightweight data-interchange format.";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-json/2022-02-20/cl-json-20220220-git.tgz";
    sha256 = "106w8afxyl02hl3zci2wxryrvdapjw3fmjwn6bxwbzl0nnz557k7";
  };

  packageName = "cl-json";

  asdFilesToKeep = ["cl-json.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-json DESCRIPTION
    JSON in Lisp. JSON (JavaScript Object Notation) is a lightweight data-interchange format.
    SHA256 106w8afxyl02hl3zci2wxryrvdapjw3fmjwn6bxwbzl0nnz557k7 URL
    http://beta.quicklisp.org/archive/cl-json/2022-02-20/cl-json-20220220-git.tgz
    MD5 8781f6947923afb0bd7b3ec328b815a3 NAME cl-json FILENAME cl-json DEPS
    ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam) VERSION 20220220-git
    SIBLINGS NIL PARASITES (cl-json.test)) */
