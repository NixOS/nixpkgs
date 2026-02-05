{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  bleak,
  pycayennelpp,
  pyserial-asyncio,
}:

buildPythonPackage rec {
  pname = "meshcore";
  version = "2.2.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uI61YDj1zYNsdcUZ2VoHQz0Xr5ja/tNH6UyBUjL8B6w=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bleak
    pycayennelpp
    pyserial-asyncio
  ];

  pythonImportsCheck = [ "meshcore" ];

  meta = {
    description = "Python library for communicating with meshcore companion radios";
    homepage = "https://github.com/meshcore-dev/meshcore_py";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
  };
}
