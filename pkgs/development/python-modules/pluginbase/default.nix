{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytest,
}:

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

  meta = {
    description = "Support library for building plugins systems in Python";
    homepage = "https://github.com/mitsuhiko/pluginbase";
    changelog = "https://github.com/mitsuhiko/pluginbase/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
