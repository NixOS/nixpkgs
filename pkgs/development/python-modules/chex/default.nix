{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, fetchpatch
, numpy
, absl-py
, toolz
, dm-tree
, jax
, jaxlib
}:

buildPythonPackage rec {
  pname = "chex";
  version = "0.1.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-V8zQ9PWLvW+sG1K6893uX62XFx8l+pB7AOqBFZd+Y0Q=";
  };

  propagatedBuildInputs = [
    absl-py
    jax
    jaxlib
    dm-tree
    toolz
  ];

  patches = [
    (fetchpatch {
      name = "fix-restrict-backends-tests.patch";
      url = "https://github.com/deepmind/chex/commit/4b4b79ff028bfedc0f8e25ef2617998d81a90918.patch";
      sha256 = "sha256-Lz2cD9z1CEq57uZqMpQhHb7mJeHd8sxA02DX/Rlor/Q=";
    })
  ];

  pythonImportsCheck = [ "chex" ];

  meta = with lib; {
    description = "Chex is a library of utilities for helping to write JAX code.";
    homepage = "https://chex.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ harwiltz ];
  };
}
