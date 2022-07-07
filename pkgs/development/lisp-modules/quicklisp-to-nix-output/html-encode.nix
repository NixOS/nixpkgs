/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "html-encode";
  version = "1.2";

  description = "A library for encoding text in various web-savvy encodings.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/html-encode/2010-10-06/html-encode-1.2.tgz";
    sha256 = "06mf8wn95yf5swhmzk4vp0xr4ylfl33dgfknkabbkd8n6jns8gcf";
  };

  packageName = "html-encode";

  asdFilesToKeep = ["html-encode.asd"];
  overrides = x: x;
}
/* (SYSTEM html-encode DESCRIPTION
    A library for encoding text in various web-savvy encodings. SHA256
    06mf8wn95yf5swhmzk4vp0xr4ylfl33dgfknkabbkd8n6jns8gcf URL
    http://beta.quicklisp.org/archive/html-encode/2010-10-06/html-encode-1.2.tgz
    MD5 67f22483fe6d270b8830f78f285a1016 NAME html-encode FILENAME html-encode
    DEPS NIL DEPENDENCIES NIL VERSION 1.2 SIBLINGS NIL PARASITES NIL) */
