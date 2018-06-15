{ fetchurl
, version ? "2.7.6"
, sha256 ? "1sqy6z1kngq91nxmv1hw4xhw1ycwx9s76hfbpcdlgkm9haji9xv7"
}:
fetchurl {
  url = "http://production.cf.rubygems.org/rubygems/rubygems-${version}.tgz";
  sha256 = sha256;
}
