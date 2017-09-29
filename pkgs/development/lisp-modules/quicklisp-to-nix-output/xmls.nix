args @ { fetchurl, ... }:
rec {
  baseName = ''xmls'';
  version = ''1.7'';

  parasites = [ "xmls/test" ];

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/xmls/2015-04-07/xmls-1.7.tgz'';
    sha256 = ''1pch221g5jv02rb21ly9ik4cmbzv8ca6bnyrs4s0yfrrq0ji406b'';
  };

  packageName = "xmls";

  asdFilesToKeep = ["xmls.asd"];
  overrides = x: x;
}
/* (SYSTEM xmls DESCRIPTION NIL SHA256
    1pch221g5jv02rb21ly9ik4cmbzv8ca6bnyrs4s0yfrrq0ji406b URL
    http://beta.quicklisp.org/archive/xmls/2015-04-07/xmls-1.7.tgz MD5
    697c9f49a60651b759e24ea0c1eb1cfe NAME xmls FILENAME xmls DEPS NIL
    DEPENDENCIES NIL VERSION 1.7 SIBLINGS NIL PARASITES (xmls/test)) */
