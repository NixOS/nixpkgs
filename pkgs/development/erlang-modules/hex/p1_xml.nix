{ buildErlang, fetchgit }:

buildErlang {
  name = "p1_xml";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/processone/xml.git";
    sha256 = "0477rq3wr0m3kg39myy0yfr0r6rxffcb4b1y9b90zldap2d7whwb";
  };
}