{ lib
, absl-py
, buildPythonPackage
, dm-tree
, fetchPypi
, h5py
, numpy
, pytest
, pytest-cov
, pytest-xdist
, rich
}:

buildPythonPackage rec {
  pname = "keras";
  version = "3.0.4";
  format = "wheel";

  src = fetchPypi {
    inherit format pname version;
    hash = "sha256-V5E45mfZxl1eMN9HAXXyxtOfldwwjJ2CWVeodUWZOfk=";
    python = "py3";
    dist = "py3";
  };

  nativeCheckInputs = [
    pytest
    pytest-cov
    pytest-xdist
  ];

  propagatedBuildInputs = [
    absl-py
    dm-tree
    h5py
    numpy
    rich
  ];

  meta = with lib; {
    description = "Deep Learning library for Theano and TensorFlow";
    homepage = "https://keras.io";
    license = licenses.mit;
    maintainers = with maintainers; [ NikolaMandic ];
  };
}
