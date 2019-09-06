args @ { fetchurl, ... }:
{
  baseName = ''cl-base64'';
  version = ''20150923-git'';

  parasites = [ "cl-base64-tests" ];

  description = ''Base64 encoding and decoding with URI support.'';

  deps = [ args."kmrcl" args."ptester" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-base64/2015-09-23/cl-base64-20150923-git.tgz'';
    sha256 = ''0haip5x0091r9xa8gdzr21s0rk432998nbxxfys35lhnyc1vgyhp'';
  };

  packageName = "cl-base64";

  asdFilesToKeep = ["cl-base64.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-base64 DESCRIPTION Base64 encoding and decoding with URI support.
    SHA256 0haip5x0091r9xa8gdzr21s0rk432998nbxxfys35lhnyc1vgyhp URL
    http://beta.quicklisp.org/archive/cl-base64/2015-09-23/cl-base64-20150923-git.tgz
    MD5 560d0601eaa86901611f1484257b9a57 NAME cl-base64 FILENAME cl-base64 DEPS
    ((NAME kmrcl FILENAME kmrcl) (NAME ptester FILENAME ptester)) DEPENDENCIES
    (kmrcl ptester) VERSION 20150923-git SIBLINGS NIL PARASITES
    (cl-base64-tests)) */
