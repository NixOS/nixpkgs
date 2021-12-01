/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-shellwords";
  version = "20150923-git";

  description = "Common Lisp port of Ruby's shellwords.rb, for escaping and
splitting strings to be passed to a shell.";

  deps = [ args."cl-ppcre" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-shellwords/2015-09-23/cl-shellwords-20150923-git.tgz";
    sha256 = "1rb0ajpl2lai6bj4x0p3wf0cnf51nnyidhca4lpqp1w1wf1vkcqk";
  };

  packageName = "cl-shellwords";

  asdFilesToKeep = ["cl-shellwords.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-shellwords DESCRIPTION
    Common Lisp port of Ruby's shellwords.rb, for escaping and
splitting strings to be passed to a shell.
    SHA256 1rb0ajpl2lai6bj4x0p3wf0cnf51nnyidhca4lpqp1w1wf1vkcqk URL
    http://beta.quicklisp.org/archive/cl-shellwords/2015-09-23/cl-shellwords-20150923-git.tgz
    MD5 c2c62c6a2ce4ed2590d60707ead2e084 NAME cl-shellwords FILENAME
    cl-shellwords DEPS ((NAME cl-ppcre FILENAME cl-ppcre)) DEPENDENCIES
    (cl-ppcre) VERSION 20150923-git SIBLINGS (cl-shellwords-test) PARASITES NIL) */
