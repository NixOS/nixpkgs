{ lib
, fetchFromGitHub
, buildPythonPackage
, jax
, jaxlib
, numpy
, parameterized
, pillow
, scipy
, tensorflow-tensorboard
}:

buildPythonPackage rec {
  pname = "objax";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "objax";
    rev = "v${version}";
    sha256 = "09gm61ghn5mi92q5mhx22mcv6aa6z78jsrnfar1hd3nwwyn9dq42";
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
    tensorflow-tensorboard
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
