{ lib
, fetchPypi
, buildPythonPackage
, pymatgen
, marshmallow
, pyyaml
, pygmo
, pandas
, scipy
, numpy
, scikitlearn
, lammps-cython
, pymatgen-lammps
, pytestrunner
, isPy3k
}:

buildPythonPackage rec {
  pname = "dftfit";
  version = "0.5.1";
  disabled = (!isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "4dcbde48948835dcf2d49d6628c9df5747a8ec505d517e374b8d6c7fe95892df";
  };

  buildInputs = [ pytestrunner ];
  propagatedBuildInputs = [
    pymatgen
    marshmallow
    pyyaml
    pygmo
    pandas
    scipy
    numpy
    scikitlearn
    lammps-cython
    pymatgen-lammps
  ];

  # tests require git lfs download. and is quite large so skip tests
  doCheck = false;
  pythonImportsCheck = [ "dftfit" ];

  meta = {
    description = "Ab-Initio Molecular Dynamics Potential Development";
    homepage = "https://gitlab.com/costrouc/dftfit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
