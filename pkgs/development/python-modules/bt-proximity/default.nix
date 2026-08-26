{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pybluez,
}:

buildPythonPackage (finalAttrs: {
  pname = "bt-proximity";
  version = "0.2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "bt_proximity";
    inherit (finalAttrs) version;
    hash = "sha256-+F2Ydjz/VxnYEuXfggnNUDFaLXLSh1GKAX/RtUNykXY=";
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
})
