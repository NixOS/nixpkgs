/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "parse-number";
  version = "v1.7";

  parasites = [ "parse-number/tests" ];

  description = "Number parsing library";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/parse-number/2018-02-28/parse-number-v1.7.tgz";
    sha256 = "11ji8856ipmqki5i4cw1zgx8hahfi8x1raz1xb20c4rmgad6nsha";
  };

  packageName = "parse-number";

  asdFilesToKeep = ["parse-number.asd"];
  overrides = x: x;
}
/* (SYSTEM parse-number DESCRIPTION Number parsing library SHA256
    11ji8856ipmqki5i4cw1zgx8hahfi8x1raz1xb20c4rmgad6nsha URL
    http://beta.quicklisp.org/archive/parse-number/2018-02-28/parse-number-v1.7.tgz
    MD5 b9ec925018b8f10193d73403873dde8f NAME parse-number FILENAME
    parse-number DEPS NIL DEPENDENCIES NIL VERSION v1.7 SIBLINGS NIL PARASITES
    (parse-number/tests)) */
