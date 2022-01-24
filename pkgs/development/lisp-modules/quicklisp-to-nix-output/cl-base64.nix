/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-base64";
  version = "20201016-git";

  parasites = [ "cl-base64/test" ];

  description = "Base64 encoding and decoding with URI support.";

  deps = [ args."kmrcl" args."ptester" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-base64/2020-10-16/cl-base64-20201016-git.tgz";
    sha256 = "1wd2sgvfrivrbzlhs1vgj762jqz7sk171ssli6gl1kfwbnphzx9z";
  };

  packageName = "cl-base64";

  asdFilesToKeep = ["cl-base64.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-base64 DESCRIPTION Base64 encoding and decoding with URI support.
    SHA256 1wd2sgvfrivrbzlhs1vgj762jqz7sk171ssli6gl1kfwbnphzx9z URL
    http://beta.quicklisp.org/archive/cl-base64/2020-10-16/cl-base64-20201016-git.tgz
    MD5 f556f7c61f785c84abdc1beb63c906ae NAME cl-base64 FILENAME cl-base64 DEPS
    ((NAME kmrcl FILENAME kmrcl) (NAME ptester FILENAME ptester)) DEPENDENCIES
    (kmrcl ptester) VERSION 20201016-git SIBLINGS NIL PARASITES
    (cl-base64/test)) */
