{ lib
, fetchFromGitHub
, buildPythonPackage
, cmake
, boost
, eigen
, gmp
, cgal_5  # see https://github.com/NixOS/nixpkgs/pull/94875 about cgal
, mpfr
, tbb
, numpy
, cython
, pybind11
, matplotlib
, scipy
, pytest
, enableTBB ? false
}:

buildPythonPackage rec {
  pname = "gudhi";
<<<<<<< HEAD
  version = "3.8.0";
=======
  version = "3.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "GUDHI";
    repo = "gudhi-devel";
    rev = "tags/gudhi-release-${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    sha256 = "sha256-f2ajy4muG9vuf4JarGWZmdk/LF9OYd2KLSaGyY6BQrY=";
=======
    sha256 = "1m03qazzfraxn62l1cb11icjz4x8q2sg9c2k3syw5v0yv9ndgx1v";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [ ./remove_explicit_PYTHONPATH.patch ];

  nativeBuildInputs = [ cmake numpy cython pybind11 matplotlib ];
  buildInputs = [ boost eigen gmp cgal_5 mpfr ]
    ++ lib.optionals enableTBB [ tbb ];
  propagatedBuildInputs = [ numpy scipy ];
  nativeCheckInputs = [ pytest ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DWITH_GUDHI_PYTHON=ON"
    "-DPython_ADDITIONAL_VERSIONS=3"
  ];

  preBuild = ''
    cd src/python
  '';

  checkPhase = ''
    rm -r gudhi
    ${cmake}/bin/ctest --output-on-failure
  '';

  pythonImportsCheck = [ "gudhi" "gudhi.hera" "gudhi.point_cloud" "gudhi.clustering" ];

  meta = {
    description = "Library for Computational Topology and Topological Data Analysis (TDA)";
    homepage = "https://gudhi.inria.fr/python/latest/";
    downloadPage = "https://github.com/GUDHI/gudhi-devel";
    license = with lib.licenses; [ mit gpl3 ];
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
