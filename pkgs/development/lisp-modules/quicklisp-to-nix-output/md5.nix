args @ { fetchurl, ... }:
rec {
  baseName = ''md5'';
  version = ''20180228-git'';

  description = ''The MD5 Message-Digest Algorithm RFC 1321'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/md5/2018-02-28/md5-20180228-git.tgz'';
    sha256 = ''1261ix6bmkjyx8bkpj6ksa0kgyrhngm31as77dyy3vfg6dvrsnd4'';
  };

  packageName = "md5";

  asdFilesToKeep = ["md5.asd"];
  overrides = x: x;
}
/* (SYSTEM md5 DESCRIPTION The MD5 Message-Digest Algorithm RFC 1321 SHA256
    1261ix6bmkjyx8bkpj6ksa0kgyrhngm31as77dyy3vfg6dvrsnd4 URL
    http://beta.quicklisp.org/archive/md5/2018-02-28/md5-20180228-git.tgz MD5
    7f250f8a2487e4e0aac1ed9c50b79b4d NAME md5 FILENAME md5 DEPS NIL
    DEPENDENCIES NIL VERSION 20180228-git SIBLINGS NIL PARASITES NIL) */
