{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyblake2,
  pysha3,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymultihash";
  version = "0.8.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ScdaGunsxtItJZBk1Fl7NoXaPwJY9N7WMuA6OnmvIVs=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    blake2 = [ pyblake2 ];
    sha3 = [ pysha3 ];
  };

  # Tests are not available
  doCheck = false;

  pythonImportsCheck = [ "multihash" ];

  meta = {
    description = "Python implementation of the multihash specification";
    homepage = "https://pypi.org/project/pymultihash/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
