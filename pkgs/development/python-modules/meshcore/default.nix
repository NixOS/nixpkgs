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
  version = "2.1.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mnr5WqH/uKzONI8lcm1GQCSlnhx6WQyqsAr12gsMKEI=";
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
