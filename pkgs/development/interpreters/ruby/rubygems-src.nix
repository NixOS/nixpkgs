{ fetchurl
, version ? "2.6.8"
, sha256 ? "1v6n6s8cq5l0xyf1fbm1w4752b9vdk3p130ar59ig72p9vqvkbl1"
}:
fetchurl {
  url = "http://production.cf.rubygems.org/rubygems/rubygems-${version}.tgz";
  sha256 = sha256;
}
