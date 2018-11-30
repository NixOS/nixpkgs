{ fetchurl
, version ? "2.7.7"
, sha256 ? "1jsmmd31j8j066b83lin4bbqz19jhrirarzb41f3sjhfdjiwkcjc"
}:
fetchurl {
  url = "https://rubygems.org/rubygems/rubygems-${version}.tgz";
  sha256 = sha256;
}
