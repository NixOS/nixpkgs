{ lib
, fetchFromGitHub
, buildPythonPackage
, jax
, jaxlib
, numpy
, parameterized
, pillow
, scipy
, tensorflow-tensorboard_2 ? null
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

  propagatedBuildInputs = [
    jax
    jaxlib
    numpy
    parameterized
    pillow
    scipy
    tensorflow-tensorboard_2
  ];

  pythonImportsCheck = [
    "objax"
  ];

  meta = with lib; {
    description = "Objax is a machine learning framework that provides an Object Oriented layer for JAX.";
    homepage = "https://github.com/google/objax";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
    # Darwin doesn't have `tensorflow-tensorboard_2` which is required by wheel deps.
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
