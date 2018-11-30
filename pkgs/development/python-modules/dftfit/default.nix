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
, pytest
, pytestcov
, pytest-benchmark
, isPy3k
, openssh
}:

buildPythonPackage rec {
  pname = "dftfit";
  version = "0.4.22";
  disabled = (!isPy3k);

  src = fetchPypi {
     inherit pname version;
     sha256 = "06dbdc21cf9ed199bfceae5301172bee2164a3b9ef6f0814a089530c320ebb3a";
  };

  buildInputs = [ pytestrunner ];
  checkInputs = [ pytest pytestcov pytest-benchmark openssh ];
  propagatedBuildInputs = [ pymatgen marshmallow pyyaml pygmo
                            pandas scipy numpy scikitlearn
                            lammps-cython pymatgen-lammps ];

  # tests require git lfs download. and is quite large so skip tests
  doCheck = false;

  meta = {
    description = "Ab-Initio Molecular Dynamics Potential Development";
    homepage = https://gitlab.com/costrouc/dftfit;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
