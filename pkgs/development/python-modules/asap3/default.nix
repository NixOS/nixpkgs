{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asap3";
  version = "3.13.9";

  build-system = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oi5rr5k1YhtmpHm0sbIlkycqslI/yT99qmQysUfqmmQ=";
  };

  nativeBuildInputs = [ which ];

  dependencies = [
    numpy
    ase
  ];

  meta = {
    description = "ASAP - As Soon As Possible, Accelerated Simuations and Potentials";
    homepage = "https://asap3.readthedocs.io/en/latest/index.html";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ sh4k095 ];
  };
}
