{
  lib,
  buildPythonPackage,
  cmake,
  eigen,
  fetchFromGitHub,
  mpi,
  pkgconfig,
  python,
  # true or false to enable/disable; null to use upstream defaults
  withHpmc ? null,
  withMd ? null,
  withMetal ? null,
  withMpcd ? null,
}:

let
  optionalCmakeBool = name: value: lib.optionals (value != null) [ (lib.cmakeBool name value) ];
in
buildPythonPackage rec {
  version = "6.0.0";
  pname = "hoomd-blue";
  pyproject = false; # Built with cmake

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "hoomd-blue";
    tag = "v${version}";
    hash = "sha256-dmDBAJU6FxMQXuMO+nE1yzOY1m6/x43eH3USBQNVu8A=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];
  buildInputs = [
    eigen
    mpi
  ];

  dependencies = with python.pkgs; [
    numpy
    mpi4py
    pybind11
  ];

  dontAddPrefix = true;
  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" doCheck)
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/${python.sitePackages}")
  ]
  ++ optionalCmakeBool "BUILD_MD" withMd
  ++ optionalCmakeBool "BUILD_HPMC" withHpmc
  ++ optionalCmakeBool "BUILD_METAL" withMetal
  ++ optionalCmakeBool "BUILD_MPCD" withMpcd;

  # Tests are performed as part of the installPhase when -DBUILD_TESTING=TRUE,
  # not the checkPhase or installCheckPhase.
  # But leave doCheck here so people can override it as they may expect.
  doCheck = true;

  meta = {
    homepage = "https://glotzerlab.engin.umich.edu/software/";
    description = "HOOMD-blue is a general-purpose particle simulation toolkit";
    changelog = "https://github.com/glotzerlab/hoomd-blue/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
