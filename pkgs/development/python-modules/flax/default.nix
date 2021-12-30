{ lib
, fetchFromGitHub
, buildPythonPackage
, matplotlib
, msgpack
, numpy
, optax
}:

buildPythonPackage rec {
  pname = "flax";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "google";
    repo = "flax";
    rev = "v${version}";
    sha256 = "0zvq0vl88hiwmss49bnm7gdmndr1dfza2bcs1fj88a9r7w9dmlsr";
  };

  propagatedBuildInputs = [
    matplotlib
    msgpack
    numpy
    optax
  ];

  pythonImportsCheck = [
    "flax"
  ];

  # Tests require deps that are non-packaged in Nix + seem to be currently broken anyway.
  doCheck = false;

  meta = with lib; {
    description = "Flax is a neural network library for JAX designed for flexibility.";
    homepage = "https://github.com/google/flax";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
