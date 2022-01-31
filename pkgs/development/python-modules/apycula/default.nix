{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools-scm
, numpy
, pandas
, pillow
, crcmod
, openpyxl
}:

buildPythonPackage rec {
  pname = "apycula";
  version = "0.2a2";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "Apycula";
    hash = "sha256-pcVoYGBhp9jyuWBJ/Rpi8cjwDgPjhJ1PrPblj5DQTpk=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    numpy
    pandas
    pillow
    crcmod
    openpyxl
  ];

  # tests require a physical FPGA
  doCheck = false;

  pythonImportsCheck = [ "apycula" ];

  meta = with lib; {
    description = "Open Source tools for Gowin FPGAs";
    homepage = "https://github.com/YosysHQ/apicula";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
