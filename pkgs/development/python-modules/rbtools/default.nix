{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "rbtools-0.6.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://downloads.reviewboard.org/releases/RBTools/0.6/RBTools-0.6.1.tar.gz";
    sha256 = "0dbpd08b0k00fszi3r7wlgn2989aypgd60jq6wc99lq4yxsmhp28";
  };
}
