{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  watchman,
}:

buildPythonPackage rec {
  pname = "pywatchman";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JTVNnjZH+UQRpME+UQyDoc7swXl3sFJbpBsW5wGceww=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace pywatchman/__init__.py --replace-fail \
      'os.environ.get("WATCHMAN_BINARY", "watchman")' \
      'os.environ.get("WATCHMAN_BINARY", "${lib.getExe watchman}")' \
  '';

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Watchman client for Python";
    homepage = "https://facebook.github.io/watchman/";
    license = licenses.bsd3;
  };
}
