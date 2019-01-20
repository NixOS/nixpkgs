{ stdenv, buildPythonPackage, fetchPypi, numpy, scipy, scikitimage, opencv3, six }:

buildPythonPackage rec {
  pname = "imgaug";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ca6bce4dcfd3e40330b593fe8e55018bf475983cc6777f8ebf5422c722fffb8";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    scikitimage
    opencv3
    six
  ];

  # disable tests when there are no tests in the PyPI archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/aleju/imgaug;
    description = "Image augmentation for machine learning experiments";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
