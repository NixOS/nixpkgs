{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
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
=======
  fetchgit,
  cmake,
  pkgconfig,
  python,
  mpi ? null,
}:

let
  components = {
    cgcmm = true;
    depreciated = true;
    hpmc = true;
    md = true;
    metal = true;
  };
  onOffBool = b: if b then "ON" else "OFF";
  withMPI = (mpi != null);
in
buildPythonPackage rec {
  version = "2.3.4";
  pname = "hoomd-blue";
  pyproject = false; # Built with cmake

  src = fetchgit {
    url = "https://bitbucket.org/glotzer/hoomd-blue";
    rev = "v${version}";
    sha256 = "0in49f1dvah33nl5n2qqbssfynb31pw1ds07j8ziryk9w252j1al";
  };

  passthru = {
    inherit components mpi;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];
<<<<<<< HEAD
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
=======
  buildInputs = lib.optionals withMPI [ mpi ];
  propagatedBuildInputs = [ python.pkgs.numpy ] ++ lib.optionals withMPI [ python.pkgs.mpi4py ];

  dontAddPrefix = true;
  cmakeFlags = [
    "-DENABLE_MPI=${onOffBool withMPI}"
    "-DBUILD_CGCMM=${onOffBool components.cgcmm}"
    "-DBUILD_DEPRECIATED=${onOffBool components.depreciated}"
    "-DBUILD_HPMC=${onOffBool components.hpmc}"
    "-DBUILD_MD=${onOffBool components.md}"
    "-DBUILD_METAL=${onOffBool components.metal}"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/${python.sitePackages}"
  ];

  # tests fail but have tested that package runs properly
  doCheck = false;
  checkTarget = "test";

  meta = with lib; {
    homepage = "http://glotzerlab.engin.umich.edu/hoomd-blue/";
    description = "HOOMD-blue is a general-purpose particle simulation toolkit";
    license = licenses.bsdOriginal;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    # Has compilation errors since some dependencies got updated, will probably
    # be fixed if updated by itself to the latest version.
    broken = true;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
