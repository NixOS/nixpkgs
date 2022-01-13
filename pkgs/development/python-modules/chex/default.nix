{ absl-py
, buildPythonPackage
, dm-tree
, fetchFromGitHub
, jax
, jaxlib
, lib
, numpy
, pytestCheckHook
, toolz
}:

buildPythonPackage rec {
  pname = "chex";
  # As of 2021-12-29, the latest official version has broken tests with jax 0.2.26:
  # `AttributeError: module 'jax.interpreters.xla' has no attribute 'xb'`
  version = "unstable-2021-12-16";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "5adc10e0b4218f8ec775567fca38b68bbad42a3a";
    sha256 = "00xib6zv9pwid2q7wcr109qj3fa3g3b852skz8444kw7r0qxy7z3";
  };

  propagatedBuildInputs = [
    absl-py
    dm-tree
    jax
    numpy
    toolz
  ];

  pythonImportsCheck = [
    "chex"
  ];

  checkInputs = [
    jaxlib
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Chex is a library of utilities for helping to write reliable JAX code.";
    homepage = "https://github.com/deepmind/chex";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
