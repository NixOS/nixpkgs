{ lib
, fetchurl
, buildPythonPackage
, lammps-mpi
, mpi
, mpi4py
, numpy
, cython
, pymatgen
, ase
, pytestrunner
, pytest
, pytestcov
, isPy3k
, openssh
}:

buildPythonPackage rec {
  pname = "lammps-cython";
  version = "0.5.7";
  disabled = (!isPy3k);

  src = fetchurl {
     url = "https://gitlab.com/costrouc/${pname}/-/archive/v${version}/${pname}-v${version}.tar.gz";
     sha256 = "1wj9scmjdl00af13b5ihfccrjpikrdgkzd88ialam1nkxvxi42bl";
  };

  buildInputs = [ cython pytestrunner ];
  checkInputs = [ pytest pytestcov openssh ];
  propagatedBuildInputs = [ mpi4py pymatgen ase numpy ];

  preBuild = ''
    echo "Creating lammps.cfg file..."
    cat << EOF > lammps.cfg
    [lammps]
    lammps_include_dir = ${lammps-mpi}/include
    lammps_library_dir = ${lammps-mpi}/lib
    lammps_library = lammps_mpi

    [mpi]
    mpi_include_dir = ${mpi}/include
    mpi_library_dir = ${mpi}/lib
    mpi_library     = mpi
    EOF
  '';

  meta = {
    description = "Pythonic Wrapper to LAMMPS using cython";
    homepage = https://gitlab.com/costrouc/lammps-cython;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
