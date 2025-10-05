{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  autoreconfHook,
  pkg-config,
  mpiCheckPhaseHook,
  gfortran,
  mpi,
  blas,
  lapack,
  fftw,
  hdf5-mpi,
  swig,
  gsl,
  harminv,
  libctl,
  libGDSII,
  guile,
  mpb,
  python,
  numpy,
  scipy,
  matplotlib,
  h5py-mpi,
  cython,
  autograd,
  mpi4py,
  distutils,
}:

assert !blas.isILP64;
assert !lapack.isILP64;

buildPythonPackage rec {
  pname = "meep";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "NanoComp";
    repo = "meep";
    tag = "v${version}";
    hash = "sha256-x5OMdV/LJfklcK1KlYS0pdotsXP/SYzF7AOW5DlJvq0=";
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
    mpb
  ];

  propagatedBuildInputs = [ mpi ];

  dependencies = [
    numpy
    scipy
    matplotlib
    h5py-mpi
    cython
    autograd
    mpi4py
  ]
  ++ lib.optionals (!pythonOlder "3.12") [
    setuptools # used in python/visualization.py
    distutils
  ];

  propagatedUserEnvPkgs = [ mpi ];

  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;

  enableParallelBuilding = true;

  preConfigure = ''
    export HDF5_MPI=ON
    export PYTHON=${python.interpreter};
  '';

  configureFlags = [
    "--without-libctl"
    "--enable-shared"
    "--with-mpi"
    "--with-openmp"
    "--enable-maintainer-mode"
  ];

  passthru = {
    inherit mpi;
  };

  /*
    This test is taken from the MEEP tutorial "Fields in a Waveguide" at
    <https://meep.readthedocs.io/en/latest/Python_Tutorials/Basics/>.
    It is important, that the test actually performs a calculation
    (calls `sim.run()`), as only then MPI will be initialised and MPI linking
    errors can be caught.
  */
  nativeCheckInputs = [
    mpiCheckPhaseHook
  ];
  pythonImportsCheck = [
    "meep.mpb"
  ];
  checkPhase = ''
    runHook preCheck

    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

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

  meta = {
    description = "Free finite-difference time-domain (FDTD) software for electromagnetic simulations";
    homepage = "https://meep.readthedocs.io/en/latest/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      sheepforce
      markuskowa
    ];
  };
}
