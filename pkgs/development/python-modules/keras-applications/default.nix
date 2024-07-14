{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  h5py,
}:

buildPythonPackage rec {
  pname = "keras-applications";
  version = "1.0.8";

  src = fetchPypi {
    pname = "Keras_Applications";
    inherit version;
    hash = "sha256-VXn5oSvN6XSPShIjOSWlm5O3OuaUdAn/NKorolgYn+U=";
  };

  # Cyclic dependency: keras-applications requires keras, which requires keras-applications
  postPatch = ''
    sed -i "s/keras>=[^']*//" setup.py
  '';

  # No tests in PyPI tarball
  doCheck = false;

  propagatedBuildInputs = [
    numpy
    h5py
  ];

  meta = with lib; {
    description = "Reference implementations of popular deep learning models";
    homepage = "https://github.com/keras-team/keras-applications";
    license = licenses.mit;
  };
}
