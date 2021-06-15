{ lib, buildPythonPackage, isPy27, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pebble";
  version = "4.6.0";
  disabled = isPy27;

  src = fetchPypi {
    pname = "Pebble";
    inherit version;
    sha256 = "0a595f7mrf89xlck9b2x83bqybc9zd9jxkl0sa5cf19vax18rg8h";
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
