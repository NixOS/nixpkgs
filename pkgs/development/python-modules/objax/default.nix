{ lib
, fetchPypi
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
  version = "1.7.0";

  # The latest release (1.7.0) has not been tagged on GitHub. Thus, we fallback to fetchPypi.
  # An issue has been opened upstream: https://github.com/google/objax/issues/263
  # src = fetchFromGitHub {
  #   owner = "google";
  #   repo = "objax";
  #   rev = "v${version}";
  #   hash = "";
  # };
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-92Z5RxYoWkMAqyF7H/MagPnC4pfXks5k9zmjvo+Z2Mc=";
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
