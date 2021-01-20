args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-features'';
  version = ''20200715-git'';

  description = ''Ensures consistent *FEATURES* across multiple CLs.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-features/2020-07-15/trivial-features-20200715-git.tgz'';
    sha256 = ''0h0xxkp7vciq5yj6a1b5k76h7mzqgb5f9v25nssijgp738nmkni2'';
  };

  packageName = "trivial-features";

  asdFilesToKeep = ["trivial-features.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-features DESCRIPTION
    Ensures consistent *FEATURES* across multiple CLs. SHA256
    0h0xxkp7vciq5yj6a1b5k76h7mzqgb5f9v25nssijgp738nmkni2 URL
    http://beta.quicklisp.org/archive/trivial-features/2020-07-15/trivial-features-20200715-git.tgz
    MD5 bb88b3e55713474bad3ef90f215f3560 NAME trivial-features FILENAME
    trivial-features DEPS NIL DEPENDENCIES NIL VERSION 20200715-git SIBLINGS
    (trivial-features-tests) PARASITES NIL) */
