{ buildErlang, fetchgit }:

buildErlang {
  name = "p1_utils";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/processone/p1_utils.git";
    sha256 = "098yhx491nyp9241jpjv4lym3k1l8pkv5milfj5mxxg199a356ir";
  };
}