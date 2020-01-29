args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-clipboard'';
  version = ''20190202-git'';

  description = ''trivial-clipboard let access system clipboard.'';

  deps = [ args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-clipboard/2019-02-02/trivial-clipboard-20190202-git.tgz'';
    sha256 = ''06ic4lqampxnycz5s0frn7f8fqjpp8mlrnsnlh77gldxlh02pwq1'';
  };

  packageName = "trivial-clipboard";

  asdFilesToKeep = ["trivial-clipboard.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-clipboard DESCRIPTION
    trivial-clipboard let access system clipboard. SHA256
    06ic4lqampxnycz5s0frn7f8fqjpp8mlrnsnlh77gldxlh02pwq1 URL
    http://beta.quicklisp.org/archive/trivial-clipboard/2019-02-02/trivial-clipboard-20190202-git.tgz
    MD5 d9b9ee3754e10888ce243172681a0db2 NAME trivial-clipboard FILENAME
    trivial-clipboard DEPS ((NAME uiop FILENAME uiop)) DEPENDENCIES (uiop)
    VERSION 20190202-git SIBLINGS (trivial-clipboard-test) PARASITES NIL) */
