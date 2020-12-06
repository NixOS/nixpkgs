{ lib, fetchPypi, fetchpatch, buildPythonPackage }:

buildPythonPackage rec {
  pname = "rocket-errbot";
  version = "1.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "181y1wqjvlry5xdzbliajvrxvswzh3myh795jnj1pm92r5grqzda";
  };

  # remove with 1.2.6
  patches = [ (fetchpatch {
    url = "https://github.com/errbotio/rocket/pull/1.patch";
    sha256 = "1s668yv5b86b78vbqwhcl44k2l16c9bhk3199yy9hayf0vkxnwif";
  }) ];

  meta = {
    homepage = "https://github.com/errbotio/rocket";
    description = "Modern, multi-threaded and extensible web server";
    license = lib.licenses.mit;
  };
}

