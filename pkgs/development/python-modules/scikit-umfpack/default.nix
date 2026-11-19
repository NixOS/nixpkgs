{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  meson-python,
  ninja,
  numpy,
  openblas,
  pkg-config,
  pytestCheckHook,
  scipy,
  suitesparse,
  swig,
}:

buildPythonPackage (finalAttrs: {
  pname = "scikit-umfpack";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-umfpack";
    repo = "scikit-umfpack";
    tag = finalAttrs.version;
    hash = "sha256-Y9EM2ktdwJaVEi+Zbc4fCfwoG6Ne9zgNWXanHQDHcKk=";
  };

  build-system = [
    meson-python
    ninja
    numpy
    pkg-config
    swig
  ];

  buildInputs = [
    openblas
    suitesparse
  ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Avoid importing from uncompiled in-tree directory during tests
  preCheck = "rm -rf scikits";

  pytestFlags = [
    "--pyargs"
    "scikits.umfpack"
  ];

  pythonImportsCheck = [
    "scikits.umfpack"
  ];

  meta = {
    description = "Python interface to UMFPACK sparse direct solver";
    homepage = "https://scikit-umfpack.github.io/scikit-umfpack";
    downloadPage = "https://github.com/scikit-umfpack/scikit-umfpack";
    license = lib.licenses.bsd3;
    # dependency packaged for emerge
    teams = with lib.teams; [ ngi ];
  };
})
