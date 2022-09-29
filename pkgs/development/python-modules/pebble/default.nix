{ lib, stdenv, buildPythonPackage, isPy27, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pebble";
  version = "5.0.0";
  disabled = isPy27;

  src = fetchPypi {
    pname = "Pebble";
    inherit version;
    sha256 = "sha256-rdKgfXHmZphfG9AkAkeH3XkPcfGi27n1+sA3y7NY4M4=";
  };

  doCheck = !stdenv.isDarwin;

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
