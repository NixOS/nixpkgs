{ buildErlang, fetchgit }:

buildErlang {
  name = "p1_stun";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/processone/stun.git";
    sha256 = "098yhx491nyp9241jpjv4lym3k1l8pkv5milfj5mxxg199a356ir";
  };
}