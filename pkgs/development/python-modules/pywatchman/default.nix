{
  lib,
  buildPythonPackage,
  fetchPypi,
  watchman,
}:

buildPythonPackage rec {
  pname = "pywatchman";
  version = "3.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-79MqFzkaWHIRjFUEHacaIJYORrpLc0QMJO+sKH7qkR4=";
  };

  postPatch = ''
    substituteInPlace pywatchman/__init__.py \
      --replace "'watchman'" "'${watchman}/bin/watchman'"
  '';

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Watchman client for Python";
    homepage = "https://facebook.github.io/watchman/";
    license = licenses.bsd3;
  };
}
