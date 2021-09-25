{ buildPythonPackage, fetchFromGitHub, lib
# propagatedBuildInputs
, absl-py, numpy, opt-einsum
# checkInputs
, jaxlib, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jax";
  version = "0.2.19";

  # Fetching from pypi doesn't allow us to run the test suite. See https://discourse.nixos.org/t/pythonremovetestsdir-hook-being-run-before-checkphase/14612/3.
  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "jax-v${version}";
    sha256 = "sha256-pVn62G7pydR7ybkf7gSbu0FlEq2c0US6H2GTBAljup4=";
  };

  # jaxlib is _not_ included in propagatedBuildInputs because there are
  # different versions of jaxlib depending on the desired target hardware. The
  # JAX project ships separate wheels for CPU, GPU, and TPU. Currently only the
  # CPU wheel is packaged.
  propagatedBuildInputs = [ absl-py numpy opt-einsum ];

  checkInputs = [ jaxlib pytestCheckHook ];
  # NOTE: Don't run the tests in the expiremental directory as they require flax
  # which creates a circular dependency. See https://discourse.nixos.org/t/how-to-nix-ify-python-packages-with-circular-dependencies/14648/2.
  # Not a big deal, this is how the JAX docs suggest running the test suite
  # anyhow.
  pytestFlagsArray = [ "-W ignore::DeprecationWarning" "tests/" ];

  meta = with lib; {
    description = "Differentiate, compile, and transform Numpy code";
    homepage    = "https://github.com/google/jax";
    license     = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
