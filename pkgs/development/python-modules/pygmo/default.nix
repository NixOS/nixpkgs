{
  lib,
  stdenv,
  toPythonModule,
  fetchFromGitHub,
  cmake,
  boost,
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
    version = "2.19.7";

    src = fetchFromGitHub {
      owner = "esa";
      repo = "pygmo2";
      tag = "v${version}";
      hash = "sha256-279KNnP11f5ob2senIVmbnlmhRp2p3RoZLsQRE6yJ5Q=";
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
      pagmo2
      pybind11
    ];

    doCheck = true;

    meta = {
      description = "Parallel optimisation for Python";
      homepage = "https://github.com/esa/pygmo2";
      license = lib.licenses.gpl3Plus;
      maintainers = [ ];
    };
  }
)
