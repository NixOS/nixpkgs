{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pebble";
  version = "5.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Pebble";
    inherit version;
    hash = "sha256-7kHDO+PUEihVcfLMfPkU1MKoGrPTiMaLPHRrerOwuGU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [
    "pebble"
  ];

  meta = with lib; {
    description = "API to manage threads and processes within an application";
    homepage = "https://github.com/noxdafox/pebble";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ orivej ];
  };
}
