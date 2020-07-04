{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, future
}:

buildPythonPackage rec {
  version = "0.2.1";
  pname = "atsim.potentials";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2abdec2fb4e8198f4e0e41634ad86625d5356a4a3f1ba1f41568d0697df8f36f";
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
