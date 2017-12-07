args @ { fetchurl, ... }:
rec {
  baseName = ''parse-number'';
  version = ''1.4'';

  parasites = [ "parse-number-tests" ];

  description = ''Number parsing library'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/parse-number/2014-08-26/parse-number-1.4.tgz'';
    sha256 = ''0y8jh7ss47z3asdxknad2g8h12nclvx0by750xniizj33b6h9blh'';
  };

  packageName = "parse-number";

  asdFilesToKeep = ["parse-number.asd"];
  overrides = x: x;
}
/* (SYSTEM parse-number DESCRIPTION Number parsing library SHA256
    0y8jh7ss47z3asdxknad2g8h12nclvx0by750xniizj33b6h9blh URL
    http://beta.quicklisp.org/archive/parse-number/2014-08-26/parse-number-1.4.tgz
    MD5 f189d474a2cd063f9743b452241e59a9 NAME parse-number FILENAME
    parse-number DEPS NIL DEPENDENCIES NIL VERSION 1.4 SIBLINGS NIL PARASITES
    (parse-number-tests)) */
