{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  cython,
  setuptools,

  # dependencies
  py-cpuinfo,
}:

buildPythonPackage (finalAttrs: {
  pname = "cityhash";
  version = "0.4.10";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-fjXamq9fz5HaP+ojQFh021X/pYsavEQdOczgyHBKnBU=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [ py-cpuinfo ];

  pythonImportsCheck = [ "cityhash" ];

  meta = {
    description = "Python bindings for FarmHash and CityHash, a fast non-cryptographic hash algorithm";
    homepage = "https://github.com/escherba/python-cityhash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lucperkins ];
  };
})
