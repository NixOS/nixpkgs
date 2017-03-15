{ fetchurl
, version ? "2.6.10"
, sha256 ? "364c0eee8e0c9e8ab4879c5035832e5a27f0c97292d2264af5ae0020585280f0"
}:
fetchurl {
  url = "http://production.cf.rubygems.org/rubygems/rubygems-${version}.tgz";
  sha256 = sha256;
}
