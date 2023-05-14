{ lib
, fetchFromGitHub
, buildPythonPackage
, jax
, jaxlib
, numpy
, parameterized
, pillow
, scipy
, tensorboard
}:

buildPythonPackage rec {
  pname = "objax";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "objax";
    rev = "v${version}";
    hash = "sha256-/6tZxVDe/3C53Re14odU9VA3mKvSj9X3/xt6bHFLHwQ=";
  };

  # Avoid propagating the dependency on `jaxlib`, see
  # https://github.com/NixOS/nixpkgs/issues/156767
  buildInputs = [
    jaxlib
  ];

  propagatedBuildInputs = [
    jax
    numpy
    parameterized
    pillow
    scipy
    tensorboard
  ];

  pythonImportsCheck = [
    "objax"
  ];

  meta = with lib; {
    description = "Objax is a machine learning framework that provides an Object Oriented layer for JAX.";
    homepage = "https://github.com/google/objax";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
