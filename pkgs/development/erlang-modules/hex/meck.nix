{ buildErlang, fetchgit }:

buildErlang {
  name = "meck";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/eproxus/meck.git";
    sha256 = "077p3v81mspy69247bz4apln3gp567m4xpmzxmdjd6pyh6m5ahpk";
  };
}