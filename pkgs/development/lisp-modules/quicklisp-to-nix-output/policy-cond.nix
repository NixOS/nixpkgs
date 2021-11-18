/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "policy-cond";
  version = "20200427-git";

  description = "Tools to insert code based on compiler policy.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/policy-cond/2020-04-27/policy-cond-20200427-git.tgz";
    sha256 = "10cyb84grz306wkz2wmhf6njvgav51yn3fk0fg3fp1q2xzcnq7y1";
  };

  packageName = "policy-cond";

  asdFilesToKeep = ["policy-cond.asd"];
  overrides = x: x;
}
/* (SYSTEM policy-cond DESCRIPTION
    Tools to insert code based on compiler policy. SHA256
    10cyb84grz306wkz2wmhf6njvgav51yn3fk0fg3fp1q2xzcnq7y1 URL
    http://beta.quicklisp.org/archive/policy-cond/2020-04-27/policy-cond-20200427-git.tgz
    MD5 c62090127d03b788518ac1257f49eda2 NAME policy-cond FILENAME policy-cond
    DEPS NIL DEPENDENCIES NIL VERSION 20200427-git SIBLINGS NIL PARASITES NIL) */
