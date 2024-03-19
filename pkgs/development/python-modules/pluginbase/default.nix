{ lib, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  version = "1.0.1";
  format = "setuptools";
  pname = "pluginbase";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff6c33a98fce232e9c73841d787a643de574937069f0d18147028d70d7dee287";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    cd tests
    PYTHONPATH=.. pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/mitsuhiko/pluginbase";
    description = "A support library for building plugins sytems in Python";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
