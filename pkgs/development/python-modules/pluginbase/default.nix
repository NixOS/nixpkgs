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
    hash = "sha256-/2wzqY/OIy6cc4QdeHpkPeV0k3Bp8NGBRwKNcNfe4oc=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    cd tests
    PYTHONPATH=.. pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/mitsuhiko/pluginbase";
    description = "Support library for building plugins sytems in Python";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
