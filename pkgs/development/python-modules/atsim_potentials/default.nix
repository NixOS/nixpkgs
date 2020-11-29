{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, future
}:

buildPythonPackage rec {
  version = "0.3.0";
  pname = "atsim.potentials";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70082fc40b0ab7565a671c2d764fe3db08bc6ce45da44e1c1e8b77a65d1f7a23";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ future ];

  # tests are not included with release
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = "https://bitbucket.org/mjdr/atsim_potentials";
    description = "Provides tools for working with pair and embedded atom method potential models including tabulation routines for DL_POLY and LAMMPS";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
