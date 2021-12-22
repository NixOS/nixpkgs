{ lib
, buildPythonPackage
, fetchFromGitHub
, jax
, jaxlib
, chex
}:

buildPythonPackage rec {
  pname = "optax";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uZ65DSPjt5tmAGjpOMDHBXYW6tpjPKN8f5fyP2FC1Wc=";
  };

  propagatedBuildInputs = [
    jax
    jaxlib
    chex
  ];

  # Test requires flax and haiku
  doCheck = false;

  postPatch = ''
    # These dirs are not packaged correctly
    rm -rf docs examples
  '';

  pythonImportsCheck = [ "optax" ];

  meta = with lib; {
    description = "Gradient processing and optimization library for JAX";
    homepage = "https://optax.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ harwiltz ];
  };
}
