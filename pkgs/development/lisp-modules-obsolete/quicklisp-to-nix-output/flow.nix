/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "flow";
  version = "20200610-git";

  description = "A flowchart and generalised graph library.";

  deps = [ args."closer-mop" args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/flow/2020-06-10/flow-20200610-git.tgz";
    sha256 = "1z1krk1iiz7n1mvpnmqnrgfhicpppb45i0jgkqnrds749xjnx194";
  };

  packageName = "flow";

  asdFilesToKeep = ["flow.asd"];
  overrides = x: x;
}
/* (SYSTEM flow DESCRIPTION A flowchart and generalised graph library. SHA256
    1z1krk1iiz7n1mvpnmqnrgfhicpppb45i0jgkqnrds749xjnx194 URL
    http://beta.quicklisp.org/archive/flow/2020-06-10/flow-20200610-git.tgz MD5
    f0767467d5e9bfda6fe5777a26719811 NAME flow FILENAME flow DEPS
    ((NAME closer-mop FILENAME closer-mop)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (closer-mop documentation-utils trivial-indent) VERSION
    20200610-git SIBLINGS (flow-visualizer) PARASITES NIL) */
