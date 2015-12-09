{ buildErlang, fetchgit, p1_stun, p1_tls, p1_utils }:

buildErlang {
  name = "esip";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/processone/p1_sip.git";
    sha256 = "0wa33m6vfxzn21pi9ik74p75nynnavc7chhs98iwbgn7alfgfyhn";
  };

  erlangDeps = [ p1_stun p1_tls p1_utils ];
}