{ fetchurl
, version ? "3.0.3"
, sha256 ? "0b6b9ads8522804xv8b8498gqwsv4qawv13f81kyc7g966y7lfmy"
}:
fetchurl {
  url = "https://rubygems.org/rubygems/rubygems-${version}.tgz";
  inherit sha256;
}
