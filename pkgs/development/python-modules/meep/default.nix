{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, autoreconfHook
, pkg-config
, mpiCheckPhaseHook
, gfortran
, mpi
, blas
, lapack
, fftw
, hdf5-mpi
, swig
, gsl
, harminv
, libctl
, libGDSII
, openssh
, guile
, python
, numpy
, scipy
, matplotlib
, h5py-mpi
, cython
, autograd
, mpi4py
}:

assert !blas.isILP64;
assert !lapack.isILP64;

buildPythonPackage rec {
  pname = "meep";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "NanoComp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-o/Xrd/Gn1RsbB+ZfggGH6/ugdsGtfTe2RgaHdpY5AyE=";
  };

  format = "other";

  # MPI is needed in nativeBuildInputs too, otherwise MPI libs will be missing
  # at runtime
  nativeBuildInputs = [
    autoreconfHook
    gfortran
    pkg-config
    swig
    mpi
  ];

  buildInputs = [
    gsl
    blas
    lapack
    fftw
    hdf5-mpi
    harminv
    libctl
    libGDSII
    guile
    gsl
  ];

  propagatedBuildInputs = [
    mpi
    numpy
    scipy
    matplotlib
    h5py-mpi
    cython
    autograd
    mpi4py
  ];

  propagatedUserEnvPkgs = [ mpi ];

  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;
  dontUseSetuptoolsCheck = true;

  enableParallelBuilding = true;

  preConfigure = ''
    export HDF5_MPI=ON
    export PYTHON=${python}/bin/${python.executable};
  '';

  configureFlags = [
    "--without-libctl"
    "--enable-shared"
    "--with-mpi"
    "--with-openmp"
    "--enable-maintainer-mode"
  ];

  passthru = { inherit mpi; };

  /*
  This test is taken from the MEEP tutorial "Fields in a Waveguide" at
  <https://meep.readthedocs.io/en/latest/Python_Tutorials/Basics/>.
  It is important, that the test actually performs a calculation
  (calls `sim.run()`), as only then MPI will be initialised and MPI linking
  errors can be caught.
  */
  doCheck = true;
  nativeCheckInputs = [ mpiCheckPhaseHook openssh ];
  checkPhase = ''
    runHook preCheck

    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    # Generate a python test script
    cat > test.py << EOF
    import meep as mp
    cell = mp.Vector3(16,8,0)
    geometry = [mp.Block(mp.Vector3(mp.inf,1,mp.inf),
                     center=mp.Vector3(),
                     material=mp.Medium(epsilon=12))]
    sources = [mp.Source(mp.ContinuousSource(frequency=0.15),
                     component=mp.Ez,
                     center=mp.Vector3(-7,0))]
    pml_layers = [mp.PML(1.0)]
    resolution = 10
    sim = mp.Simulation(cell_size=cell,
                    boundary_layers=pml_layers,
                    geometry=geometry,
                    sources=sources,
                    resolution=resolution)
    sim.run(until=200)
    EOF

    ${mpi}/bin/mpiexec -np 2 python3 test.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "Free finite-difference time-domain (FDTD) software for electromagnetic simulations";
    homepage = "https://meep.readthedocs.io/en/latest/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sheepforce markuskowa ];
  };
}
