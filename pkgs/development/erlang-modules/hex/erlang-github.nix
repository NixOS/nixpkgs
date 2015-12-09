{ buildErlang, fetchgit, lager, jiffy, ibrowse }:

buildErlang {
  name = "erlang-github";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/inaka/erlang-github.git";
    sha256 = "1qkfym0bywwwy58v3y38dh0wanfkwn3yr5a19nh8wdjfrwfa3179";
  };

  erlangDeps = [ lager jiffy ibrowse ];
}