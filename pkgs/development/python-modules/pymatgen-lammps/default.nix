{ lib
, fetchurl
, buildPythonPackage
, pymatgen
, lammps
, pytestrunner
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "pymatgen-lammps";
  version = "0.4.5";
  disabled = (!isPy3k);

  src = fetchurl {
     url = "https://gitlab.com/costrouc/${pname}/-/archive/v${version}/${pname}-v${version}.tar.gz";
     sha256 = "0shldl8is3195jmji7dr3zsh1bzxlahaqrmpr28niks7nnfj80fx";
  };

  buildInputs = [ pytestrunner ];
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ pymatgen ];

  meta = {
    description = "A LAMMPS wrapper using pymatgen";
    homepage = https://gitlab.com/costrouc/pymatgen-lammps;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
