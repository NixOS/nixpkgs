/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "parse-declarations-1_dot_0";
  version = "parse-declarations-20101006-darcs";

  description = "Library to parse and rebuild declarations.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/parse-declarations/2010-10-06/parse-declarations-20101006-darcs.tgz";
    sha256 = "0r85b0jfacd28kr65kw9c13dx4i6id1dpmby68zjy63mqbnyawrd";
  };

  packageName = "parse-declarations-1.0";

  asdFilesToKeep = ["parse-declarations-1.0.asd"];
  overrides = x: x;
}
/* (SYSTEM parse-declarations-1.0 DESCRIPTION
    Library to parse and rebuild declarations. SHA256
    0r85b0jfacd28kr65kw9c13dx4i6id1dpmby68zjy63mqbnyawrd URL
    http://beta.quicklisp.org/archive/parse-declarations/2010-10-06/parse-declarations-20101006-darcs.tgz
    MD5 e49222003e5b59c5c2a0cf58b86cfdcd NAME parse-declarations-1.0 FILENAME
    parse-declarations-1_dot_0 DEPS NIL DEPENDENCIES NIL VERSION
    parse-declarations-20101006-darcs SIBLINGS NIL PARASITES NIL) */
