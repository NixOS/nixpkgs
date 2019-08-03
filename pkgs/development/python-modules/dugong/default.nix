{ buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "dugong";
  version = "3.7.4";

  disabled = pythonOlder "3.3"; # Library does not support versions older than 3.3

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    sha256 = "1fb9kwib6jsd09bxiz70av6g0blscygkx7xzaz1b7ibd28ms77zd";
  };
}
