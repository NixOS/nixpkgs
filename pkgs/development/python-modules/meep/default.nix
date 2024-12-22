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
}:

assert !blas.isILP64;
assert !lapack.isILP64;

buildPythonPackage rec {
  pname = "meep";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "NanoComp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-TB85obdk8pSWRaz3+3I6P6+dQtCHosWHRnKGck/wG9Q=";
  };

  format = "other";

  # https://github.com/NanoComp/meep/issues/2819
  postPatch = lib.optionalString (!pythonOlder "3.12") ''
    substituteInPlace configure.ac doc/docs/setup.py python/visualization.py \
      --replace-fail "distutils" "setuptools._distutils"
  '';

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

  propagatedBuildInputs =
    [
      mpi
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
