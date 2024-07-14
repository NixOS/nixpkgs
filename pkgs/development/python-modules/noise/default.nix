{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "noise";
  version = "1.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V6J5dDZXQ5H/Y6ER6FLlOkFk7Nga0jY5ZBdDzRogm2U=";
  };

  meta = with lib; {
    homepage = "https://github.com/caseman/noise";
    description = "Native-code and shader implementations of Perlin noise";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
