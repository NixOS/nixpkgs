{
  lib,
  stdenv,
  toPythonModule,
  fetchFromGitHub,
  cmake,
  boost,
  eigen,
  ipopt,
  nlopt,
  pagmo2,
  python,
  cloudpickle,
  ipyparallel,
  numba,
  numpy,
  pybind11,
}:

toPythonModule (
  stdenv.mkDerivation rec {
    pname = "pygmo";
    version = "2.19.6";

    src = fetchFromGitHub {
      owner = "esa";
      repo = "pygmo2";
      rev = "refs/tags/v${version}";
      hash = "sha256-umXK8LGJJ6Xj6UbJ5k/DM/nYayjl+jBXtjar5/dWqFM=";
    };

    cmakeFlags = [ "-DPYGMO_INSTALL_PATH=${placeholder "out"}/${python.sitePackages}" ];

    nativeBuildInputs = [ cmake ];

    propagatedBuildInputs = [
      cloudpickle
      ipyparallel
      numba
      numpy
      python
    ];

    buildInputs = [
      boost
      eigen
      ipopt
      nlopt
      pagmo2
      pybind11
    ];

    doCheck = true;

    meta = with lib; {
      description = "Parallel optimisation for Python";
      homepage = "https://github.com/esa/pygmo2";
      license = licenses.gpl3Plus;
      maintainers = [ ];
    };
  }
)
