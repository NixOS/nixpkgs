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
    sha256 = "5579f9a12bcde9748f4a12233925a59b93b73ae6947409ff34aa2ba258189fe5";
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
