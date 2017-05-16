{ lib, fetchurl, fetchpatch, buildPythonPackage }:

buildPythonPackage rec {
  name = "rocket-errbot-${version}";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://pypi/r/rocket-errbot/${name}.tar.gz";
    sha256 = "181y1wqjvlry5xdzbliajvrxvswzh3myh795jnj1pm92r5grqzda";
  };

  patches = [ (fetchpatch {
    url = "https://github.com/errbotio/rocket/pull/1.patch";
    sha256 = "0v9zjp4ls32vkpr4b6kjflz4ny2fwj6hwshbnjmhdzc4hnmnzf7x";
  }) ];

  meta = {
    homepage = https://github.com/errbotio/rocket;
    description = "Modern, multi-threaded and extensible web server";
    license = lib.licenses.mit;
  };
}

