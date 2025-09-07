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
  version = "2.1.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-aEuY4N4QIJTPjonhtAYG97yIXnxKp1I5kt25pCiJjOM=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bleak
    pycayennelpp
    pyserial-asyncio
  ];

  pythonImportsCheck = [ "meshcore" ];

  meta = with lib; {
    description = "Python library for communicating with meshcore companion radios";
    homepage = "https://github.com/meshcore-dev/meshcore_py";
    license = licenses.mit;
    maintainers = [ maintainers.haylin ];
  };
}
