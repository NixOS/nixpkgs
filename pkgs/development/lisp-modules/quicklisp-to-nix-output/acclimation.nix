/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "acclimation";
  version = "20200925-git";

  description = "Library supporting internationalization";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/acclimation/2020-09-25/acclimation-20200925-git.tgz";
    sha256 = "11vw1h5zxicj5qxb1smiyjxafw8xk0isnzcf5g0lqis3y9ssqxbw";
  };

  packageName = "acclimation";

  asdFilesToKeep = ["acclimation.asd"];
  overrides = x: x;
}
/* (SYSTEM acclimation DESCRIPTION Library supporting internationalization
    SHA256 11vw1h5zxicj5qxb1smiyjxafw8xk0isnzcf5g0lqis3y9ssqxbw URL
    http://beta.quicklisp.org/archive/acclimation/2020-09-25/acclimation-20200925-git.tgz
    MD5 8ce10864baef6fb0e11c78e2ee0b0ddb NAME acclimation FILENAME acclimation
    DEPS NIL DEPENDENCIES NIL VERSION 20200925-git SIBLINGS
    (acclimation-temperature) PARASITES NIL) */
