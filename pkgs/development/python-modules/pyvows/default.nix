{ lib
, buildPythonPackage
, fetchPypi
, gevent
, preggy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyvows";
  version = "3.0.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyVows";
    inherit version;
    sha256 = "sha256-2+4umWLNkbFlCpfFwX0FA2N0zOZhst/YM4ozBfXoaMI=";
  };

  propagatedBuildInputs = [
    gevent
    preggy
  ];

  pythonImportsCheck = [ "pyvows" ];

  meta = with lib; {
    description = "BDD test engine based on Vows.js";
    homepage = "https://github.com/heynemann/pyvows";
    license = licenses.mit;
    maintainers = with maintainers; [ joachimschmidt557 ];
  };
}
