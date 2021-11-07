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
  version = "0.0.1a12";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "Apycula";
    sha256 = "0qhnh049q4mafnvax6jx3s1q5vf8a8y5q7j1faz04c4sa45zamjc";
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
