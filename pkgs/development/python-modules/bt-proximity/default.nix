{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pybluez,
}:

buildPythonPackage rec {
  pname = "bt-proximity";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "bt_proximity";
    inherit version;
    sha256 = "0xlif91vblbz065531yjf8nmlcahrl4q5pz52bc1jmzz7iv9hpgq";
  };

  build-system = [ setuptools ];

  dependencies = [ pybluez ];

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [ "bt_proximity" ];

  meta = {
    description = "Bluetooth Proximity Detection using Python";
    homepage = "https://github.com/FrederikBolding/bluetooth-proximity";
    maintainers = with lib.maintainers; [ peterhoeg ];
    license = lib.licenses.asl20;
  };
}
