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
  version = "0.0.1a11";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "Apycula";
    sha256 = "0fwk1pgphpgj0lazjy40ii08xq2qi6bvrfc30rwfj52yff1s9akn";
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
