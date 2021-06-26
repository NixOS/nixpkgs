{ lib
, buildPythonPackage
, fetchPypi
, configparser
, pyparsing
, pytest
, future
, openpyxl
, wrapt
}:

buildPythonPackage rec {
  version = "0.4.0";
  pname = "atsim.potentials";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c3e4e2323e969880f17a9924642e0991be5761f50b254bcbadd046db3be6390";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [
    configparser
    future
    openpyxl
    pyparsing
    wrapt
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "wrapt==1.11.2" "wrapt~=1.11"
  '';

  # tests are not included with release
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = "https://github.com/mjdrushton/atsim-potentials";
    description = "Provides tools for working with pair and embedded atom method potential models including tabulation routines for DL_POLY and LAMMPS";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
    broken = true; # missing cexprtk package
  };
}
