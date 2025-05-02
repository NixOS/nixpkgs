/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lambda-fiddle";
  version = "20190710-git";

  description = "A collection of functions to process lambda-lists.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lambda-fiddle/2019-07-10/lambda-fiddle-20190710-git.tgz";
    sha256 = "0v4qjpp9fq9rlxhr5f6mjs5f076xrjk19rl6qgp1ap1ykcrx8k4j";
  };

  packageName = "lambda-fiddle";

  asdFilesToKeep = ["lambda-fiddle.asd"];
  overrides = x: x;
}
/* (SYSTEM lambda-fiddle DESCRIPTION
    A collection of functions to process lambda-lists. SHA256
    0v4qjpp9fq9rlxhr5f6mjs5f076xrjk19rl6qgp1ap1ykcrx8k4j URL
    http://beta.quicklisp.org/archive/lambda-fiddle/2019-07-10/lambda-fiddle-20190710-git.tgz
    MD5 78f68f144ace9cb8f634ac14b3414e5e NAME lambda-fiddle FILENAME
    lambda-fiddle DEPS NIL DEPENDENCIES NIL VERSION 20190710-git SIBLINGS NIL
    PARASITES NIL) */
