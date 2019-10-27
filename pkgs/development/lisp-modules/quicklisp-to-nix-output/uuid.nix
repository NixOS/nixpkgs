args @ { fetchurl, ... }:
{
  baseName = ''uuid'';
  version = ''20130813-git'';

  description = ''UUID Generation'';

  deps = [ args."ironclad" args."nibbles" args."trivial-utf-8" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uuid/2013-08-13/uuid-20130813-git.tgz'';
    sha256 = ''1ph88gizpkxqigfrkgmq0vd3qkgpxd9zjy6qyr0ic4xdyyymg1hf'';
  };

  packageName = "uuid";

  asdFilesToKeep = ["uuid.asd"];
  overrides = x: x;
}
/* (SYSTEM uuid DESCRIPTION UUID Generation SHA256
    1ph88gizpkxqigfrkgmq0vd3qkgpxd9zjy6qyr0ic4xdyyymg1hf URL
    http://beta.quicklisp.org/archive/uuid/2013-08-13/uuid-20130813-git.tgz MD5
    e9029d9437573ec2ffa2b474adf95daf NAME uuid FILENAME uuid DEPS
    ((NAME ironclad FILENAME ironclad) (NAME nibbles FILENAME nibbles)
     (NAME trivial-utf-8 FILENAME trivial-utf-8))
    DEPENDENCIES (ironclad nibbles trivial-utf-8) VERSION 20130813-git SIBLINGS
    NIL PARASITES NIL) */
