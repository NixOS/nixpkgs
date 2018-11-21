{ lib, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "drmaa";
  version = "0.7.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hjmkyfdlbpw84gl0bra352ir3a68q77p3gknb0dah7wibchqm0j";
  };

  doCheck = false; # testing requires a specific DRMAA system running

  meta = with lib; {
    description = "Python wrapper around the C DRMAA library";
    homepage = https://github.com/pygridtools/drmaa-python;
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
