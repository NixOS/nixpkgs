{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, pybind11
, numpy
, pytestCheckHook
, absl-py
}:

buildPythonPackage rec {
  pname = "ml-dtypes";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "ml_dtypes";
    rev = "refs/tags/v${version}";
    hash = "sha256-eqajWUwylIYsS8gzEaCZLLr+1+34LXWhfKBjuwsEhhI=";
    # Since this upstream patch (https://github.com/jax-ml/ml_dtypes/commit/1bfd097e794413b0d465fa34f2eff0f3828ff521),
    # the attempts to use the nixpkgs packaged eigen dependency have failed.
    # Hence, we rely on the bundled eigen library.
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "numpy~=1.21.2" "numpy" \
      --replace "numpy~=1.23.3" "numpy" \
      --replace "pybind11~=2.10.0" "pybind11" \
      --replace "setuptools~=67.6.0" "setuptools"
  '';

  nativeBuildInputs = [
    setuptools
    pybind11
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
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage samuela ];
  };
}
