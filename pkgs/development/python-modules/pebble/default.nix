{ lib, buildPythonPackage, isPy27, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pebble";
  version = "4.6.3";
  disabled = isPy27;

  src = fetchPypi {
    pname = "Pebble";
    inherit version;
    sha256 = "694e1105db888f3576b8f00662f90b057cf3780e6f8b7f57955a568008d0f497";
  };

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "API to manage threads and processes within an application";
    homepage = "https://github.com/noxdafox/pebble";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ orivej ];
  };
}
