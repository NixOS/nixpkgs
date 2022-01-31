/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "named-readtables";
  version = "20211209-git";

  parasites = [ "named-readtables/test" ];

  description = "Library that creates a namespace for named readtable
  akin to the namespace of packages.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/named-readtables/2021-12-09/named-readtables-20211209-git.tgz";
    sha256 = "0mlxbs7r6ksjk9ilsgp756qp4jlgplr30kxdn7npq27wg0rpvz2n";
  };

  packageName = "named-readtables";

  asdFilesToKeep = ["named-readtables.asd"];
  overrides = x: x;
}
/* (SYSTEM named-readtables DESCRIPTION
    Library that creates a namespace for named readtable
  akin to the namespace of packages.
    SHA256 0mlxbs7r6ksjk9ilsgp756qp4jlgplr30kxdn7npq27wg0rpvz2n URL
    http://beta.quicklisp.org/archive/named-readtables/2021-12-09/named-readtables-20211209-git.tgz
    MD5 52def9392c93bb9c6da4b957549bcb0b NAME named-readtables FILENAME
    named-readtables DEPS NIL DEPENDENCIES NIL VERSION 20211209-git SIBLINGS
    NIL PARASITES (named-readtables/test)) */
