{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build-system
  setuptools,

  # dependencies
  numpy,

  # tests
  absl-py,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ml-dtypes";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "ml_dtypes";
    rev = "refs/tags/v${version}";
    hash = "sha256-+6job9fEHVguh9JBE/NUv+QezwQohuKPO8DlhbaawZ4=";
    # Since this upstream patch (https://github.com/jax-ml/ml_dtypes/commit/1bfd097e794413b0d465fa34f2eff0f3828ff521),
    # the attempts to use the nixpkgs packaged eigen dependency have failed.
    # Hence, we rely on the bundled eigen library.
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch2 {
      name = "numpy2-compat.patch";
      url = "https://github.com/jax-ml/ml_dtypes/commit/204df1147fd568f65890d958b6cdfa4dc55a226c.patch";
      hash = "sha256-IPHE6bQTbM0Ky5X6FDwwD/1eXL+kcA/D8pDGihAiJrQ=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=73.0.1" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    absl-py
    pytestCheckHook
  ];

  preCheck = ''
    # remove src module, so tests use the installed module instead
    mv ./ml_dtypes/tests ./tests
    rm -rf ./ml_dtypes
  '';

  pythonImportsCheck = [ "ml_dtypes" ];

  meta = {
    description = "Stand-alone implementation of several NumPy dtype extensions used in machine learning libraries";
    homepage = "https://github.com/jax-ml/ml_dtypes";
    changelog = "https://github.com/jax-ml/ml_dtypes/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      samuela
    ];
  };
}
