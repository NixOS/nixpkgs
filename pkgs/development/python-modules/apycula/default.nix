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
  version = "0.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "Apycula";
    hash = "sha256-yuDyW1JXavI6U3B3hx3kdHBuVCQd2rJJqgZ0z15ahaw=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    pillow
    crcmod
    openpyxl
  ];

  # tests require a physical FPGA
  doCheck = false;

  pythonImportsCheck = [
    "apycula"
  ];

  meta = with lib; {
    description = "Open Source tools for Gowin FPGAs";
    homepage = "https://github.com/YosysHQ/apicula";
    changelog = "https://github.com/YosysHQ/apicula/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
