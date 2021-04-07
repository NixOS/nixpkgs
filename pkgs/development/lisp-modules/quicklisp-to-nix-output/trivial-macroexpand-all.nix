/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-macroexpand-all";
  version = "20171023-git";

  description = "Call each implementation's macroexpand-all equivalent";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-macroexpand-all/2017-10-23/trivial-macroexpand-all-20171023-git.tgz";
    sha256 = "0h5h9zn32pn26x7ll9h08g0csr2f5hvk1wgbr7kdhx5zbrszd7zm";
  };

  packageName = "trivial-macroexpand-all";

  asdFilesToKeep = ["trivial-macroexpand-all.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-macroexpand-all DESCRIPTION
    Call each implementation's macroexpand-all equivalent SHA256
    0h5h9zn32pn26x7ll9h08g0csr2f5hvk1wgbr7kdhx5zbrszd7zm URL
    http://beta.quicklisp.org/archive/trivial-macroexpand-all/2017-10-23/trivial-macroexpand-all-20171023-git.tgz
    MD5 9cec494869344eb64ebce802c01928c5 NAME trivial-macroexpand-all FILENAME
    trivial-macroexpand-all DEPS NIL DEPENDENCIES NIL VERSION 20171023-git
    SIBLINGS NIL PARASITES NIL) */
