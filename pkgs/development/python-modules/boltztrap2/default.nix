{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  stdenv,
  spglib,
  numpy,
  scipy,
  matplotlib,
  ase,
  netcdf4,
  cython,
  cmake,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "boltztrap2";
  version = "25.3.1";

  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  src = fetchFromGitLab {
    owner = "sousaw";
    repo = "BoltzTraP2";
    tag = "v${version}";
    hash = "sha256-eocstudmgMkuxa94txU8uqIp8HpNEuWQys7WvRRZ4as=";
  };

  postPatch = ''
    substituteInPlace external/spglib-1.9.9/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.4)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace pyproject.toml \
      --replace-fail "numpy>=2.0.0" "numpy"
  '';

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    cython
  ];

  dependencies = [
    spglib
    numpy
    scipy
    matplotlib
    ase
    netcdf4
  ];

  pythonImportsCheck = [ "BoltzTraP2" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preInstallCheck = ''
    tar xf data.tar.xz
    rm -rf BoltzTraP2
  '';

  pytestFlags = [ "tests" ];

  disabledTests = lib.optionals (stdenv.system != "x86_64-linux") [
    # Tests np.load numpy arrays from disk that were, apparently, saved on
    # x86_64-linux. Then these files are used to compare results of
    # calculations, which won't work as expected if running on a different
    # platform.
    "test_DOS_Si"
    "test_BTPDOS_Si"
    "test_calc_cv_Si"
    "test_fermiintegrals_Si"
    "test_fitde3D_saved_noder"
  ];

  meta = with lib; {
    description = "Band-structure interpolator and transport coefficient calculator";
    mainProgram = "btp2";
    homepage = "http://www.boltztrap.org/";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
