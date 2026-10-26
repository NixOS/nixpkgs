{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,

  cmake,
  gcc14,
  python,
  eigen,
  mpi,
  cereal,
  numpy,
  pybind11,
  rowan,
  gsd,
  h5py,
  mpi4py,
  sybil,

  # https://github.com/glotzerlab/hoomd-blue/blob/v7.2.0/BUILDING.rst#configure
  withHpmc ? true,
  withMd ? true,
  withMetal ? true,
  withMpcd ? true,
  withMpi ? false,
}:
buildPythonPackage (finalAttrs: {
  version = "7.2.0";
  pname = "hoomd-blue";
  pyproject = false; # build with cmake

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "hoomd-blue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7Pa9XRQXIMxXW+ko2fJdZKwChXukTOhrEabADAL2tW0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    gcc14
  ]
  ++ lib.optionals withMpi [
    mpi
  ];

  buildInputs = [
    eigen
    cereal
  ]
  ++ lib.optionals withMpi [
    cereal
  ];

  dependencies = [
    numpy
    pybind11
  ];

  dontAddPrefix = true;
  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/${python.sitePackages}")

    (lib.cmakeBool "BUILD_MD" withMd)
    (lib.cmakeBool "BUILD_HPMC" withHpmc)
    (lib.cmakeBool "BUILD_METAL" withMetal)
    (lib.cmakeBool "BUILD_MPCD" withMpcd)

    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)

    (lib.cmakeBool "ENABLE_MPI" withMpi)
  ]
  ++ (lib.optional withMpi (lib.cmakeFeature "MPI_HOME" "${lib.getDev mpi}"));

  doCheck = true;

  nativeCheckInputs = [
    pytestCheckHook
    gsd
    h5py
    rowan
    sybil
  ]
  ++ lib.optionals withMpi [
    mpi4py
  ];

  pytestFlags = [ "hoomd" ];

  meta = {
    homepage = "https://glotzerlab.engin.umich.edu/software/";
    description = "HOOMD-blue is a general-purpose particle simulation toolkit";
    changelog = "https://github.com/glotzerlab/hoomd-blue/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
