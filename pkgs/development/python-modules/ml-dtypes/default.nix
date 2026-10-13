{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  scikit-build-core,

  # dependencies
  numpy,

  # tests
  absl-py,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ml-dtypes";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "ml_dtypes";
    tag = "v${finalAttrs.version}";
    # Since this upstream patch (https://github.com/jax-ml/ml_dtypes/commit/1bfd097e794413b0d465fa34f2eff0f3828ff521),
    # the attempts to use the nixpkgs packaged eigen dependency have failed.
    # Hence, we rely on the bundled eigen library.
    fetchSubmodules = true;
    hash = "sha256-NvsZrSiXfJMEVdpxBD3JmyAy5inEKSZVeLvI7YiGBy0=";
  };

  build-system = [
    cmake
    ninja
    scikit-build-core
  ];
  dontUseCmakeConfigure = true;

  dependencies = [ numpy ];

  nativeCheckInputs = [
    absl-py
    pytestCheckHook
  ];

  # Otherwise Python import `ml_dtypes` from the sources instead of the installed files in $out.
  preCheck = ''
    rm ml_dtypes/__init__.py
  '';

  pythonImportsCheck = [ "ml_dtypes" ];

  meta = {
    description = "Stand-alone implementation of several NumPy dtype extensions used in machine learning libraries";
    homepage = "https://github.com/jax-ml/ml_dtypes";
    changelog = "https://github.com/jax-ml/ml_dtypes/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      samuela
    ];
  };
})
