args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-clipboard'';
  version = ''20200925-git'';

  description = ''trivial-clipboard let access system clipboard.'';

  deps = [ args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-clipboard/2020-09-25/trivial-clipboard-20200925-git.tgz'';
    sha256 = ''1aksag9nfklkg0bshd7dxfip4dj9gl3x0cbisgd2c143k2csb1yc'';
  };

  packageName = "trivial-clipboard";

  asdFilesToKeep = ["trivial-clipboard.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-clipboard DESCRIPTION
    trivial-clipboard let access system clipboard. SHA256
    1aksag9nfklkg0bshd7dxfip4dj9gl3x0cbisgd2c143k2csb1yc URL
    http://beta.quicklisp.org/archive/trivial-clipboard/2020-09-25/trivial-clipboard-20200925-git.tgz
    MD5 4098d356666a3a3a1ff6a45b10e28354 NAME trivial-clipboard FILENAME
    trivial-clipboard DEPS ((NAME uiop FILENAME uiop)) DEPENDENCIES (uiop)
    VERSION 20200925-git SIBLINGS (trivial-clipboard-test) PARASITES NIL) */
