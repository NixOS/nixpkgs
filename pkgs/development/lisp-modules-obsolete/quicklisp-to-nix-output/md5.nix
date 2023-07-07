/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "md5";
  version = "20210630-git";

  description = "The MD5 Message-Digest Algorithm RFC 1321";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/md5/2021-06-30/md5-20210630-git.tgz";
    sha256 = "16kilbw3p68xf5fnj00xpvm4l8ylk5k9z6vbnq244ip0sygfizcv";
  };

  packageName = "md5";

  asdFilesToKeep = ["md5.asd"];
  overrides = x: x;
}
/* (SYSTEM md5 DESCRIPTION The MD5 Message-Digest Algorithm RFC 1321 SHA256
    16kilbw3p68xf5fnj00xpvm4l8ylk5k9z6vbnq244ip0sygfizcv URL
    http://beta.quicklisp.org/archive/md5/2021-06-30/md5-20210630-git.tgz MD5
    ecb1fa8eea6848c2f14fdfeb03d47056 NAME md5 FILENAME md5 DEPS NIL
    DEPENDENCIES NIL VERSION 20210630-git SIBLINGS NIL PARASITES NIL) */
