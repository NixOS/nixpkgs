{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pybind11
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ml-dtypes";
  version = "0.2.0";

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

  nativeBuildInputs = [ pybind11 ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "ml_dtypes" ];

  meta = with lib; {
    description = "A stand-alone implementation of several NumPy dtype extensions used in machine learning libraries";
    homepage = "https://github.com/jax-ml/ml_dtypes";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage samuela ];
  };
}
