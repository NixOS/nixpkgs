{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "colorclass";
  version = "2.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bU/ih3ZhZqmMp7xvYxLa8EoEgbHtpD5xc0hAUcCrQ2Y=";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Robpol86/colorclass";
    license = licenses.mit;
    description = "Automatic support for console colors";
  };
}
