/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "net_dot_didierverna_dot_asdf-flv";
  version = "asdf-flv-version-2.1";

  description = "ASDF extension to provide support for file-local variables.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/asdf-flv/2016-04-21/asdf-flv-version-2.1.tgz";
    sha256 = "12k0d4xyv6s9vy6gq18p8c9bm334jsfjly22lhg680kx2zr7y0lc";
  };

  packageName = "net.didierverna.asdf-flv";

  asdFilesToKeep = ["net.didierverna.asdf-flv.asd"];
  overrides = x: x;
}
/* (SYSTEM net.didierverna.asdf-flv DESCRIPTION
    ASDF extension to provide support for file-local variables. SHA256
    12k0d4xyv6s9vy6gq18p8c9bm334jsfjly22lhg680kx2zr7y0lc URL
    http://beta.quicklisp.org/archive/asdf-flv/2016-04-21/asdf-flv-version-2.1.tgz
    MD5 2b74b721b7e5335d2230d6b95fc6be56 NAME net.didierverna.asdf-flv FILENAME
    net_dot_didierverna_dot_asdf-flv DEPS NIL DEPENDENCIES NIL VERSION
    asdf-flv-version-2.1 SIBLINGS NIL PARASITES NIL) */
