{ fetchurl
, version ? "2.6.6"
, sha256 ? "0x0ldlwr627d0brw96jdbscib6d2nk19izvnh8lzsasszi1k5rkq"
}:
fetchurl {
  url = "http://production.cf.rubygems.org/rubygems/rubygems-${version}.tgz";
  sha256 = sha256;
}
