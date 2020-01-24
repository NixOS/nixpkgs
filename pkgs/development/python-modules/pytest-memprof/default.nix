{ lib, buildPythonPackage, fetchPypi, psutil, pytest }:

buildPythonPackage rec {
  pname = "pytest-memprof";
  version = "0.2.0";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "c9bc9f1edf2ab90dcac4208412d397b19f5ed450f14e0dba8a8951be0606af67";
  };
   
  propagatedBuildInputs = [ psutil pytest ];

  meta = with lib; {
    description = "Estimates memory consumption of test functions";
    homepage = "https://sissource.ethz.ch/schmittu/pytest-memprof";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
