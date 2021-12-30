{ lib
, fetchPypi
, buildPythonPackage
, absl-py
, chex
, jaxlib
, numpy
}:

buildPythonPackage rec {
  pname = "optax";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04z64swrx5rvysxf0349f9bri7prh22q2n4albz55qj16xgc6vi0";
  };

  propagatedBuildInputs = [
    absl-py
    chex
    jaxlib
    numpy
  ];

  pythonImportsCheck = [
    "chex"
  ];

  # Circular dependency on flax.
  doCheck = false;

  meta = with lib; {
    description = "Optax is a gradient processing and optimization library for JAX.";
    homepage = "https://github.com/deepmind/optax";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
