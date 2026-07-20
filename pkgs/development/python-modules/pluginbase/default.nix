{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pluginbase";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/2wzqY/OIy6cc4QdeHpkPeV0k3Bp8NGBRwKNcNfe4oc=";
  };

  build-system = [ setuptools ];

  # https://github.com/mitsuhiko/pluginbase/issues/24
  doCheck = false;

  pythonImportsCheck = [ "pluginbase" ];

  meta = {
    description = "Support library for building plugins systems in Python";
    homepage = "https://github.com/mitsuhiko/pluginbase";
    changelog = "https://github.com/mitsuhiko/pluginbase/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
