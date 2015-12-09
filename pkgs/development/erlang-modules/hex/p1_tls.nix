{ buildErlang, fetchgit }:

buildErlang {
  name = "p1_tls";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/processone/tls.git";
    sha256 = "1ah22hcad4s3rapcjcgpp3mmcgpzl4bj9q465zfjmgv9ca9p6hmv";
  };
}