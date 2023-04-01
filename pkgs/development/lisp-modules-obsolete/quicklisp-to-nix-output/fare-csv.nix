/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "fare-csv";
  version = "20171227-git";

  description = "Robust CSV parser and printer";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/fare-csv/2017-12-27/fare-csv-20171227-git.tgz";
    sha256 = "1hkzg05kq2c4xihsfx4wk1k6mmjq2fw40id8vy0315rpa47a5i7x";
  };

  packageName = "fare-csv";

  asdFilesToKeep = ["fare-csv.asd"];
  overrides = x: x;
}
/* (SYSTEM fare-csv DESCRIPTION Robust CSV parser and printer SHA256
    1hkzg05kq2c4xihsfx4wk1k6mmjq2fw40id8vy0315rpa47a5i7x URL
    http://beta.quicklisp.org/archive/fare-csv/2017-12-27/fare-csv-20171227-git.tgz
    MD5 1d73aaac9fcd86cc5ddb72019722bc2a NAME fare-csv FILENAME fare-csv DEPS
    NIL DEPENDENCIES NIL VERSION 20171227-git SIBLINGS NIL PARASITES NIL) */
