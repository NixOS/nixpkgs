{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "inotify-simple";
  version = "1.1.8";

  src = fetchPypi {
    pname = "inotify_simple";
    inherit version;
    sha256 = "1pfqvnynwh318cakldhg7535kbs02asjsgv6s0ki12i7fgfi0b7w";
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
