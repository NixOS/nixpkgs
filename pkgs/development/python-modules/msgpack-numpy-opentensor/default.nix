{
  lib,
  buildPythonPackage,
  fetchPypi,
  msgpack,
  numpy,
  python,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "msgpack-numpy-opentensor";
  version = "0.5.0";
  pyproject = true;

  __structuredAttrs = true;

  # The GitHub repo does not tag the same releases as PyPi, so we use PyPi directly instead.
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ITIywg4u/VKOyKmIK2Beith8/DW1ffz+/gXTOqqr5XQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    msgpack
    numpy
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} tests.py

    runHook postCheck
  '';

  meta = {
    description = "Numpy data serialization using msgpack (opentensor fork)";
    homepage = "https://github.com/opentensor/msgpack-numpy";
    changelog = "https://pypi.org/project/msgpack-numpy-opentensor/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kilyanni ];
  };
})
