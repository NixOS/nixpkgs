{ fetchurl
, version ? "2.4.8"
, sha256 ? "0pl4civyf0vhqsqbqaivvxrb3fsg8sid9a8jv5vfnk4hypz3ahss"
}:
fetchurl {
  url = "http://production.cf.rubygems.org/rubygems/rubygems-${version}.tgz";
  sha256 = sha256;
}
