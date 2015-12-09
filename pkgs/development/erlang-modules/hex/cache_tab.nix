{ buildErlang, fetchgit, p1_utils }:

buildErlang {
  name = "cache_tab";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/processone/cache_tab.git";
    sha256 = "1hw3hgzddcanzs6w88n66j2kdyz44zjayjwc3pg88bcr4rcwx46f";
  };

  erlangDeps = [ p1_utils ];
}