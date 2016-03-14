{ fetchurl
, version ? "2.6.2"
, sha256 ? "1j02ajici555f35vd6ky6m4bxs8lh8nqb1c59qqib4jp4ibcv6zy"
}:
fetchurl {
  url = "http://production.cf.rubygems.org/rubygems/rubygems-${version}.tgz";
  sha256 = sha256;
}
