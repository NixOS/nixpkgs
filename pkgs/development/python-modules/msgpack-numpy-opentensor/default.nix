{
  lib,
  buildPythonPackage,
  fetchPypi,
  msgpack,
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "msgpack-numpy-opentensor";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ITIywg4u/VKOyKmIK2Beith8/DW1ffz+/gXTOqqr5XQ=";
  };

  propagatedBuildInputs = [
    msgpack
    numpy
  ];

  pythonImportsCheck = [ "msgpack_numpy" ];

  meta = {
    description = "Numpy data serialization using msgpack (opentensor fork)";
    homepage = "https://pypi.org/project/msgpack-numpy-opentensor";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kilyanni ];
  };
})
