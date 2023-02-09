{ lib
, fetchurl
, buildPythonPackage
, pymatgen
, pytest-runner
, pytestCheckHook
, isPy3k
}:

buildPythonPackage rec {
  pname = "pymatgen-lammps";
  version = "0.4.5";
  disabled = !isPy3k;

  src = fetchurl {
     url = "https://gitlab.com/costrouc/${pname}/-/archive/v${version}/${pname}-v${version}.tar.gz";
     sha256 = "0shldl8is3195jmji7dr3zsh1bzxlahaqrmpr28niks7nnfj80fx";
  };

  buildInputs = [ pytest-runner ];
  nativeCheckInputs = [ pytestCheckHook ];
  propagatedBuildInputs = [ pymatgen ];

  pythonImportsCheck = [ "pmg_lammps" ];

  meta = {
    description = "A LAMMPS wrapper using pymatgen";
    homepage = "https://gitlab.com/costrouc/pymatgen-lammps";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
    # not compatible with recent versions of pymatgen
    broken = true;
  };
}
