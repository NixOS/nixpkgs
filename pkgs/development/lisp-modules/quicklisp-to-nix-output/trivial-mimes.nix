args @ { fetchurl, ... }:
{
  baseName = ''trivial-mimes'';
  version = ''20190710-git'';

  description = ''Tiny library to detect mime types in files.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-mimes/2019-07-10/trivial-mimes-20190710-git.tgz'';
    sha256 = ''0z6m26gs0ilqs183xb4a5acpka9md10szbbdpm5xzjrhl15nb4jn'';
  };

  packageName = "trivial-mimes";

  asdFilesToKeep = ["trivial-mimes.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-mimes DESCRIPTION
    Tiny library to detect mime types in files. SHA256
    0z6m26gs0ilqs183xb4a5acpka9md10szbbdpm5xzjrhl15nb4jn URL
    http://beta.quicklisp.org/archive/trivial-mimes/2019-07-10/trivial-mimes-20190710-git.tgz
    MD5 b7fa1cb9382a2a562343c6ca87b1b4ac NAME trivial-mimes FILENAME
    trivial-mimes DEPS NIL DEPENDENCIES NIL VERSION 20190710-git SIBLINGS NIL
    PARASITES NIL) */
