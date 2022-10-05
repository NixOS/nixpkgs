{ lib, stdenv, buildPythonPackage, isPy27, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pebble";
  version = "5.0.1";
  disabled = isPy27;

  src = fetchPypi {
    pname = "Pebble";
    inherit version;
    sha256 = "sha256-7kHDO+PUEihVcfLMfPkU1MKoGrPTiMaLPHRrerOwuGU=";
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
