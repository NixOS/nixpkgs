{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "inotify-simple";
  version = "1.2.1";

  src = fetchPypi {
    pname = "inotify_simple";
    inherit version;
    sha256 = "132craajflksgxxwjawj73nn1ssv8jn58j3k5vvyiq03avbz4sfv";
  };

  # The package has no tests
  doCheck = false;

  meta = with lib; {
    description = "A simple Python wrapper around inotify";
    homepage = https://github.com/chrisjbillington/inotify_simple;
    license = licenses.bsd2;
    maintainers = with maintainers; [ earvstedt ];
  };
}
