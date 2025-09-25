{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  scikit-build-core,
  nanobind,
  cmake,
  ninja,
  pkg-config,
  blas,
  lapack,
  numpy,
  sympy,
  scipy,
  matplotlib,
  fenics-ufl,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fenics-basix";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fenics";
    repo = "basix";
    tag = "v${version}";
    hash = "sha256-jLQMDt6zdl+oixd5Qevn4bvxBsXpTNcbH2Os6TC9sRQ=";
  };

  dontUseCmakeConfigure = true;

  build-system = [
    scikit-build-core
    nanobind
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  dependencies = [
    numpy
  ];

  buildInputs = [
    blas
    lapack
  ];

  cmakeFlags = [
    # Prefer finding BLAS and LAPACK via pkg-config.
    # Avoid using the Accelerate.framework from the Darwin SDK.
    # Also, avoid mistaking BLAS for LAPACK.
    (lib.cmakeBool "BLA_PREFER_PKGCONFIG" true)
  ];

  pythonImportsCheck = [
    "basix"
  ];

  nativeCheckInputs = [
    sympy
    scipy
    matplotlib
    fenics-ufl
    pytest-xdist
    pytestCheckHook
  ];

  meta = {
    homepage = "https://fenicsproject.org";
    downloadPage = "https://github.com/fenics/basix";
    description = "Finite element definition and tabulation runtime library";
    changelog = "https://github.com/fenics/basix/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
