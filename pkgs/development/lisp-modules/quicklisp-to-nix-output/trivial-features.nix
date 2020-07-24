args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-features'';
  version = ''20190710-git'';

  description = ''Ensures consistent *FEATURES* across multiple CLs.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-features/2019-07-10/trivial-features-20190710-git.tgz'';
    sha256 = ''04i2vhhij8pwy46zih1dkm8ldy8qqgrncxxqd4y1sgiq3airg3dy'';
  };

  packageName = "trivial-features";

  asdFilesToKeep = ["trivial-features.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-features DESCRIPTION
    Ensures consistent *FEATURES* across multiple CLs. SHA256
    04i2vhhij8pwy46zih1dkm8ldy8qqgrncxxqd4y1sgiq3airg3dy URL
    http://beta.quicklisp.org/archive/trivial-features/2019-07-10/trivial-features-20190710-git.tgz
    MD5 3907b044e00a812ebae989134fe57c55 NAME trivial-features FILENAME
    trivial-features DEPS NIL DEPENDENCIES NIL VERSION 20190710-git SIBLINGS
    (trivial-features-tests) PARASITES NIL) */
