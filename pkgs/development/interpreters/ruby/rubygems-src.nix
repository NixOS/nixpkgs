{ fetchurl
, version ? "2.6.13"
, sha256 ? "1j98ww8cz9y4wwshg7p4i4acrmls3ywkyj1nlkh4k3bywwm50hfh"
}:
fetchurl {
  url = "http://production.cf.rubygems.org/rubygems/rubygems-${version}.tgz";
  sha256 = sha256;
}
