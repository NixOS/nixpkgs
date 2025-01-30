{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cmake,
  setuptools,
  boost,
  eigen,
  gmp,
  cgal,
  mpfr,
  tbb,
  numpy,
  cython,
  pybind11,
  matplotlib,
  scipy,
  pytest,
  enableTBB ? false,
}:

buildPythonPackage rec {
  pname = "gudhi";
  version = "3.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GUDHI";
    repo = "gudhi-devel";
    rev = "tags/gudhi-release-${version}";
    fetchSubmodules = true;
    hash = "sha256-zHjSGm3hk3FZQmyQ03y14vJp5xeoofvij1hczKidvVA=";
  };

  nativeBuildInputs = [
    cmake
    numpy
    cython
    pybind11
    matplotlib
    setuptools
  ];
  buildInputs = [
    boost
    eigen
    gmp
    cgal
    mpfr
  ] ++ lib.optionals enableTBB [ tbb ];
  propagatedBuildInputs = [
    numpy
    scipy
  ];
  nativeCheckInputs = [ pytest ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_GUDHI_PYTHON" true)
    (lib.cmakeFeature "Python_ADDITIONAL_VERSIONS" "3")
  ];

  prePatch = ''
    substituteInPlace src/python/CMakeLists.txt \
      --replace '"''${GUDHI_PYTHON_PATH_ENV}"' ""
  '';

  preBuild = ''
    cd src/python
  '';

  checkPhase = ''
    runHook preCheck

    rm -r gudhi
    ctest --output-on-failure

    runHook postCheck
  '';

  pythonImportsCheck = [
    "gudhi"
    "gudhi.hera"
    "gudhi.point_cloud"
    "gudhi.clustering"
  ];

  meta = {
    description = "Library for Computational Topology and Topological Data Analysis (TDA)";
    homepage = "https://gudhi.inria.fr/python/latest/";
    downloadPage = "https://github.com/GUDHI/gudhi-devel";
    license = with lib.licenses; [
      mit
      gpl3
    ];
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
