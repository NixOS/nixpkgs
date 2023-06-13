{ buildPythonPackage
, fetchFromGitHub
, lib
, numpy
, pybind11
}:

buildPythonPackage rec {
  pname = "ml-dtypes";
  version = "0.2.0";
  # As of 2023-06-06, they have both pyproject.toml and setup.py, seems like setuptools works more easily.
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "ml_dtypes";
    rev = "refs/tags/v${version}";
    # ml-dtypes has eigen pinned as a submodule. My efforts to use nixpkgs's eigen have thus far failed :/
    fetchSubmodules = true;
    hash = "sha256-eqajWUwylIYsS8gzEaCZLLr+1+34LXWhfKBjuwsEhhI=";
  };

  nativeBuildInputs = [ numpy pybind11 ];

  pythonImportsCheck = [ "ml_dtypes" ];

  meta = with lib; {
    description = "A stand-alone implementation of several NumPy dtype extensions used in machine learning";
    homepage = "https://github.com/jax-ml/ml_dtypes";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
