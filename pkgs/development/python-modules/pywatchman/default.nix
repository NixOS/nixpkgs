{
  lib,
  buildPythonPackage,
  fetchPypi,
  watchman,
}:

buildPythonPackage rec {
  pname = "pywatchman";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JTVNnjZH+UQRpME+UQyDoc7swXl3sFJbpBsW5wGceww=";
  };

  postPatch = ''
    substituteInPlace pywatchman/__init__.py \
      --replace "'watchman'" "'${watchman}/bin/watchman'"
  '';

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Watchman client for Python";
    homepage = "https://facebook.github.io/watchman/";
    license = lib.licenses.bsd3;
  };
}
