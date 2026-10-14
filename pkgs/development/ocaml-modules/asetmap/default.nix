{
  lib,
  fetchurl,
  buildTopkgPackage,
}:

buildTopkgPackage rec {
  pname = "asetmap";
  version = "0.8.1";
  src = fetchurl {
    url = "https://github.com/dbuenzli/asetmap/archive/refs/tags/v${version}.tar.gz";
    sha256 = "051ky0k62xp4inwi6isif56hx5ggazv4jrl7s5lpvn9cj8329frj";
  };

  meta = {
    license = lib.licenses.isc;
  };
}
