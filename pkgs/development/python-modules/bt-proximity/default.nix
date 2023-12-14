{ lib
, buildPythonPackage
, fetchPypi
, pybluez
}:

buildPythonPackage rec {
  pname = "bt-proximity";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "bt_proximity";
    inherit version;
    sha256 = "0xlif91vblbz065531yjf8nmlcahrl4q5pz52bc1jmzz7iv9hpgq";
  };

  propagatedBuildInputs = [
    pybluez
  ];

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [ "bt_proximity" ];

  meta = with lib; {
    description = "Bluetooth Proximity Detection using Python";
    homepage = "https://github.com/FrederikBolding/bluetooth-proximity";
    maintainers = with maintainers; [ peterhoeg ];
    license = licenses.asl20;
  };
}
