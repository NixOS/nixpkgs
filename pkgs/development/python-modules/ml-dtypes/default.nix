{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, numpy
, pytestCheckHook
, absl-py
}:

buildPythonPackage rec {
  pname = "ml-dtypes";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "ml_dtypes";
    rev = "refs/tags/v${version}";
    hash = "sha256-epWunA5FULmCuTABl3uckFuNaSEpqJxtp0n0loCb6Q0=";
    # Since this upstream patch (https://github.com/jax-ml/ml_dtypes/commit/1bfd097e794413b0d465fa34f2eff0f3828ff521),
    # the attempts to use the nixpkgs packaged eigen dependency have failed.
    # Hence, we rely on the bundled eigen library.
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "numpy~=1.21.2" "numpy" \
      --replace "numpy~=1.23.3" "numpy" \
      --replace "numpy~=1.26.0" "numpy" \
      --replace "setuptools~=68.1.0" "setuptools"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    absl-py
  ];

  preCheck = ''
    # remove src module, so tests use the installed module instead
    mv ./ml_dtypes/tests ./tests
    rm -rf ./ml_dtypes
  '';

  pythonImportsCheck = [
    "ml_dtypes"
  ];

  meta = with lib; {
    description = "A stand-alone implementation of several NumPy dtype extensions used in machine learning libraries";
    homepage = "https://github.com/jax-ml/ml_dtypes";
    changelog = "https://github.com/jax-ml/ml_dtypes/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage samuela ];
  };
}
