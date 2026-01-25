{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "inotify-simple";
  version = "2.0.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "inotify_simple";
    inherit version;
    sha256 = "sha256-8BC7vYKDvXGp9Ost6UdlgE7eJL1HMgsObvQTblQc3Cw=";
  };

  # The package has no tests
  doCheck = false;

  pythonImportsCheck = [ "inotify_simple" ];

  meta = {
    description = "Simple Python wrapper around inotify";
    homepage = "https://github.com/chrisjbillington/inotify_simple";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ erikarvstedt ];
  };
}
