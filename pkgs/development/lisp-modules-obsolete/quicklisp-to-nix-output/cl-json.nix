/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-json";
  version = "20141217-git";

  parasites = [ "cl-json.test" ];

  description = "JSON in Lisp. JSON (JavaScript Object Notation) is a lightweight data-interchange format.";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-json/2014-12-17/cl-json-20141217-git.tgz";
    sha256 = "00cfppyi6njsbpv1x03jcv4zwplg0q1138174l3wjkvi3gsql17g";
  };

  packageName = "cl-json";

  asdFilesToKeep = ["cl-json.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-json DESCRIPTION
    JSON in Lisp. JSON (JavaScript Object Notation) is a lightweight data-interchange format.
    SHA256 00cfppyi6njsbpv1x03jcv4zwplg0q1138174l3wjkvi3gsql17g URL
    http://beta.quicklisp.org/archive/cl-json/2014-12-17/cl-json-20141217-git.tgz
    MD5 9d873fa462b93c76d90642d8e3fb4881 NAME cl-json FILENAME cl-json DEPS
    ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam) VERSION 20141217-git
    SIBLINGS NIL PARASITES (cl-json.test)) */
