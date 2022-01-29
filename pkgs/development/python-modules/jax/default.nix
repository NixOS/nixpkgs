{ lib
, absl-py
, buildPythonPackage
, fetchFromGitHub
, jaxlib
, numpy
, opt-einsum
, pytestCheckHook
, pythonOlder
, scipy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "jax";
  version = "0.2.27";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "${pname}-v${version}";
    sha256 = "0r1rs1zn0nzf8wpy6g5wrn2yrgi12gg2i7l285ka5d8wczjnbq47";
  };

  patches = [
    # See https://github.com/google/jax/issues/7944
    ./cache-fix.patch
  ];

  # jaxlib is _not_ included in propagatedBuildInputs because there are
  # different versions of jaxlib depending on the desired target hardware. The
  # JAX project ships separate wheels for CPU, GPU, and TPU. Currently only the
  # CPU wheel is packaged.
  propagatedBuildInputs = [
    absl-py
    numpy
    opt-einsum
    scipy
    typing-extensions
  ];

  checkInputs = [
    jaxlib
    pytestCheckHook
  ];

  # NOTE: Don't run the tests in the expiremental directory as they require flax
  # which creates a circular dependency. See https://discourse.nixos.org/t/how-to-nix-ify-python-packages-with-circular-dependencies/14648/2.
  # Not a big deal, this is how the JAX docs suggest running the test suite
  # anyhow.
  pytestFlagsArray = [
    "-W ignore::DeprecationWarning"
    "tests/"
  ];

  pythonImportsCheck = [
    "jax"
  ];

  meta = with lib; {
    description = "Differentiate, compile, and transform Numpy code";
    homepage = "https://github.com/google/jax";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
